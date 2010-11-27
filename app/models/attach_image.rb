class AttachImage < ActiveRecord::Base
  set_primary_key :attachable_id
  belongs_to :attachable, :polymorphic => true
  belongs_to :image
end

