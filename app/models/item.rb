class Item < ApplicationRecord

  enum status: { inactive: 0, active: 1 }

  mount_uploader :image, ImageUploader

  default_scope { where(deleted_at: nil) }

  def destroy
    update(deleted_at: Time.current)
  end

end
