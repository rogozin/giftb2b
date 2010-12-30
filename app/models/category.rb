class Category < ActiveRecord::Base
  acts_as_tree :order => "sort_order,name"
  has_many :products, :through => :product_category
  has_many :product_category, :dependent => :delete_all
  has_many :attach_images, :as => :attachable, :dependent => :delete_all, :foreign_key => :attachable_id
  has_many :images, :through => :attach_images
  has_many :property_category, :dependent => :delete_all
  has_many :properties, :through=>:property_category
  validates :name, :presence => true
  validates  :permalink, :allow_nil => true, :uniqueness => true

  default_scope order("sort_order, name")
  scope :active, where(:active => 1)
  scope :virtual, where(:kind => 0)
  scope :catalog, where(:kind => 1)  
  scope :thematic, where(:kind => 2)
  scope :analog, where(:kind => 3)

  before_save :set_permalink
  before_create :set_category_kind
  before_update :virtual_category_rules
  after_save :clear_cache
    
  @@disable_cache = false

  def self.disable_cache
    @@disable_cache = true
  end
  
  def self.enable_cache
    @@disable_cache = false
    Category.clearcache
  end  
  
  def self.cached_active_categories 
    Rails.cache.fetch('active_categories', :expires_in =>24.hours) { active.all}
  end

  def self.cached_all_categories 
    Rails.cache.fetch('all_categories', :expires_in =>1.hours) { all}
  end

  def child_for_virtual
    Category.all(:conditions=>"virtual_id=#{id}")
  end
  
  
  def self.tree_nesting(categories, start, res=[])
    res.push start.id.to_i if start
    if start  && start.parent_id     
      prior = categories.select {|cat| cat.id==start.parent_id}.first
      res = tree_nesting(categories,prior,res) if prior
    end
    res
  end
  
    def self.tree_nesting_by_name(categories, start, res=[])
    res.push start.name if start
    if start  && start.parent_id     
      prior = categories.select {|cat| cat.id==start.parent_id}.first
      res = tree_nesting_by_name(categories,prior,res) if prior
    end
    res
  end
  
  def self.tree_childs(categories, start, res=[],init = true)
    if init
      res<< start.id
      children = categories.select{|cat| cat.parent_id == start.id }
      return tree_childs(categories,children,res,false) if children && children.size>0
    else
      start.each  do |cat_item| 
         res<< cat_item.id 
        children = categories.select{|cat| cat.parent_id==cat_item.id }
        tree_childs(categories,children,res,false) if children && children.size>0
      end
    end  
    res
  end
 
   def self.kinds
    [["Виртуальный",0],["Каталог",1],["Тематический",2],["Аналоги",3]] 
  end
 
  def catalog_type
    case self.kind
      when 0
      "virtuals"
      when 2
      "thematic"  
      when 3
      "analogs"
     else 
      "catalog" 
    end
  end
 
  def self.clearcache
    unless @@disable_cache
      Rails.cache.delete('active_categories')
      Rails.cache.delete('all_categories')
    end      
  end 
  
  def kind_name
     Category.kinds.find{|i| i.last==self[:kind]}.first || "Не определено"  
  end 
      
  def to_param  
    self.permalink 
  end  
    
private 
 
  def set_category_kind
     self.kind=self.parent.kind if self.parent    
  end
  
  def virtual_category_rules
    #У виртуальной категории не может быть значения в поле virtual_id и не может быть родительской категории
    if self[:kind]==0  
      self[:virtual_id]==nil
      self[:parent_id]==nil
    end
    Category.update_all("kind=#{kind}",["id in (?)",Category.tree_childs(Category.cached_all_categories,self)]) unless parent_id
  end
  
  def set_permalink
    if self.permalink.blank? 
      self.permalink = (Category.find_all_by_permalink(self.name.parameterize).size>0 ? "#{self.parent_id || Time.now.strftime("%d-%m-%Y-%H-%M-%S")}-#{self.name.parameterize}" : self.name.parameterize )
    else 
      self.permalink= self.permalink.parameterize
    end
  end
      
 def clear_cache
    unless @@disable_cache
      Rails.cache.delete('active_categories')
      Rails.cache.delete('all_categories')    
    end
 end
  
  
end

