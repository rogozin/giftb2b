#encoding: utf-8;
class ContentImage < ActiveRecord::Base
  has_attached_file :gallery_item, :styles => {:thumb => "120x120" }
end
