require 'rack/throttle'
require 'dalli'
require 'resolv'
# we limit daily API usage
class Defender < Rack::Throttle::Hourly

  IP_WHITELIST = %w(87.236.190.194 66.249.66.161 66.249.71.168 213.180.209.10 95.108.247.252 66.249.66.5 66.249.72.134 66.249.66.22)  
  LINKS_WHITELIST = [ /^\/api\/categories.json$/, /^\/api\/categories\/analogs.json$/, /^\/api\/categories\/thematics.json$/, /^\/api\/products\/lk.json/ ]
    
  def initialize(app)
    host, ttl = "127.0.0.1:11211", 3600
    options = {
      :ttl => ttl,
      :host => host,
      :cache => Dalli::Client.new(host, :namespace => "gift_#{Rails.env}_defender", :expires_in => ttl),
      :max => 100
    }
    @app, @options = app, options
  end

  def allowed?(request)
    if need_defense?(request)   
      req_count =  cache_incr(request)      
      log(request, req_count)
      req_count < max_allowed(request) || search_bot?(request)       
    else 
      true
    end
  end

  def call(env)
    status, heders, body = super
    request = Rack::Request.new(env)
    if need_defense?(request) && api_request?(request)
      heders['X-RateLimit-Limit']     = max_allowed(request).to_s
      heders['X-RateLimit-Remaining'] = ([0, max_allowed(request) - (cache.get(cache_key(request)).to_i rescue 1)].max).to_s
    end
    [status, heders, body]
    #allowed?(request) ? app.call(env) : rate_limit_exceeded
  end

  def cache_incr(request)
    key = cache_key(request)
    count = cache.incr(key) || set_default_value(key)
    count
  end

  protected
    def max_allowed(request)
      max_allowed = api_request?(request) ?  max_per_hour*1.2 : max_per_hour     
    end
  
    def set_default_value(key)
      cache.set(key, 1, @options[:ttl], :raw => true)
      1
    end
  
    def api_request?(request)
        request.fullpath =~ /^\/api/
    end  
  
    def need_defense?(request) 
      IP_WHITELIST.exclude?(request.ip) && LINKS_WHITELIST.select{|li| request.fullpath =~ li }.empty?  && request.fullpath =~ /^\/(api\/products|products|categories\/)/
    end
    
    def search_bot?(request)
       bots_cache(request).include?(request.ip)
    end
          
    private
    
    def bots_cache(request)
      list = cache.get("bot_list") || []
      resolv_blacklist = cache.get("resolv_blacklist") || []
      if resolv_blacklist.exclude?(request.ip) && list.exclude?(request.ip) 
        if Resolv.new.getname(request.ip) =~ /(googlebot.com|yandex|msnbot|mail.ru|amazonaws.com)/
          list << request.ip
          cache.set("bot_list", list)                    
        end
      end
      list
    rescue Resolv::ResolvError
      write_log(request, "ResolvError")
      resolv_blacklist << request.ip
      cache.set("resolv_blacklist", resolv_blacklist)                    
     	list
    end
    
    def log(request, req_count)
     max = max_allowed(request)
     write_log(request, "Warning: #{max/2} request for this ip")  if req_count == max/2 && !search_bot?(request) 
     write_log(request, "Error: #{max} (max) request for this ip. Blocked.") if req_count >= max && !search_bot?(request)
    end  

    def write_log(request, message)
       File.open(File.join(Rails.root,'log/defender/defender.log'), 'a+') do |f|
        f.puts "#{Time.now}\t#{request.ip}\t#{request.fullpath}\t#{request.user_agent}\t#{message}"      
      end
    end

end
