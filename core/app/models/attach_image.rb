#encoding: utf-8;
class AttachImage < ActiveRecord::Base
  set_primary_keys :attachable_id, :image_id, :attachable_type
  belongs_to :attachable, :polymorphic => true, :primary_key => :id
  belongs_to :image
  before_save :main_img_rule

  private
  
  def main_img_rule
    AttachImage.update_all "main_img=0", "attachable_id=#{self.attachable_id} and attachable_type='#{self.attachable_type}'" if main_img
  end
end

