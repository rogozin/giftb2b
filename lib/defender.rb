require 'rack/throttle'
require 'dalli'
# we limit daily API usage
class Defender < Rack::Throttle::Hourly

  WHITELIST = %w(87.236.190.194 66.249.66.161 66.249.71.168 207.46.199.37 157.55.18.24 207.46.199.53 79.142.165.179 157.55.16.87 207.46.204.240 213.180.209.10 65.52.110.152 194.186.248.18 65.52.104.87 95.108.247.252 178.65.33.101)

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

  # this method checks if request needs throttling. 
  # If so, it increases usage counter and compare it with maximum 
  # allowed API calls. Returns true if a request can be handled.
   def allowed?(request)
     max_allowed = api_request?(request) ?  max_per_hour*3 : max_per_hour     
    if need_defense?(request)   
      req_count =  cache_incr(request)
      write_log(request, "Warning: #{max_allowed} request for this ip") if req_count == max_allowed/2
      if req_count < max_allowed
        true
      else
        write_log(request, "Error: #{max_allowed} (max) request for this ip")
        false
      end
    else 
      true
    end
  end

  def call(env)
    status, heders, body = super
    request = Rack::Request.new(env)
    # just to be nice for our clients we inform them how many
    # requests remaining does they have
    if need_defense?(request)
      heders['X-RateLimit-Limit']     = max_per_window.to_s
      heders['X-RateLimit-Remaining'] = ([0, max_per_window - (cache.get(cache_key(request)).to_i rescue 1)].max).to_s
    end
    [status, heders, body]
    #allowed?(request) ? app.call(env) : rate_limit_exceeded
  end

  # rack-throttle can use many backends for storing request counter.
  # We use Redis only so we can use it's features. In this case 
  # key increase and key expiration
  def cache_incr(request)
    key = cache_key(request)
    count = cache.incr(key) || set_default_value(key)
    count
  end

  protected
    def set_default_value(key)
      cache.set(key, 1, @options[:ttl], :raw => true)
      1
    end
  
    def api_request?(request)
        request.fullpath =~ /^\/api/
    end  
  
    def need_defense?(request)     
      WHITELIST.exclude?(request.ip) && request.fullpath =~ /^(\/api|\/products|\/categories)/
    end
    
    def yandex?(request)
      #TODO use it with memcache
      #Socket.gethostbyaddr([request.ip.gsub(".", ",")].pack("CCCC")).first =~ /yandex/
      request.user_agent =~ /yandex.com\/bots/
    end
    
    def write_log(request, message)
       File.open(File.join(Rails.root,'log/defender/defender.log'), 'a+') do |f|
        f.puts "#{Time.now}\t#{request.ip}\t#{request.fullpath}\t#{request.user_agent}\t#{message}"      
      end
    end

end
