#encoding: utf-8;
module Admin::BaseHelper

   # Make an admin tab that coveres one or more resources supplied by symbols
  # Option hash may follow. Valid options are
  #   * :label to override link text, otherwise based on the first resource name (translated)
  #   * :route to override automatically determining the default route
  #   * :match_path as an alternative way to control when the tab is active, /products would match /admin/products, /admin/products/5/variants etc.
  def tab(*args)
    options = {:label => args.first.to_s}
    if args.last.is_a?(Hash)
      options = options.merge(args.pop)
    end
    options[:route] ||=  "admin_#{args.first}"

    destination_url =  options[:url] ? options[:url] : send("#{options[:route]}_path")

    return("") unless current_user

    ## if more than one form, it'll capitalize all words
    label_with_first_letters_capitalized = options[:label].gsub(/\b\w/){$&.upcase}
    link = link_to(label_with_first_letters_capitalized, destination_url)

    css_classes = []

    selected = if options[:match_path]
      request.fullpath.starts_with?("/admin#{options[:match_path]}")
    else
      args.include?(controller.controller_name.to_sym)
    end
    css_classes << 'selected' if selected

    if options[:css_class]
      css_classes << options[:css_class]
    end
    content_tag('li', link, :class => css_classes.join(' '))
  end

  def is_admin?
   current_user && current_user.is_admin?
  end
  
  def is_admin_user?
   current_user && current_user.is_admin_user?
  end
  
  def is_firm_user?
   current_user && current_user.is_firm_user?   
  end

  def tree_ul(acts_as_tree_set, child = nil, init=true, &block)
    if init 
      roots = acts_as_tree_set.select{|set_item| set_item.parent_id==nil}    
    else
      roots = child
    end   
    if roots.size > 0
      ret = "<ul#{" class='treeview'" if init}> \n"
      roots.each do |item|
        #next if item.parent_id && init
        ret += "<li id='item_#{item.id}'>"
        ret += yield item
        children=acts_as_tree_set.select {|set_item| set_item.parent_id==item.id}
        ret += tree_ul(acts_as_tree_set,children, false, &block) if children.size > 0
        ret += "</li> \n"
      end
      ret += "</ul> \n"
    end
    raw ret
  end
  
  
  def host_by_site_id(site_id)
    site_id.zero? ? "giftb2b.ru" : "giftpoisk.ru"
  end
  
 def tree_select(categories, model, name,options={}, selected=nil, level=0, init=true,child = nil)
    html = ""
    if init
        unless name.blank?
          html << "<select name=\"#{model}[#{name}]\" id=\"#{model}_#{name}\" >\n"
        else 
          html << "<select name=\"#{model}\" id=\"#{model}\">\n"
        end
      html << "\t<option value=\"\"><-Категория-></option>\n"
      html << "\t<option value=\"#{options[:value]}\">#{options[:name]}</option>\n" unless options.blank?
      roots = categories.select{|set_item| set_item.parent_id==nil}    
    else
        roots = child
    end
    if roots.size > 0
      level += 1 # keep position
      roots.collect do |cat|
        html << "\t<option value=\"#{cat.id}\" style=\"padding-left:#{level * 10}px;\""
        html << ' selected="selected"' if selected && cat.id == selected
        html << ">#{' -'*level} #{cat.name}</option>\n"
        children=categories.select {|set_item| set_item.parent_id==cat.id}
        html << tree_select(categories, model, name, {}, selected, level, false, children) if children.size > 0
      end
    end
    html << "</select>\n" if init
    raw html
  end

end

