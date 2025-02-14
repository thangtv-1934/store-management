class Store < ApplicationRecord
  belongs_to :user
  has_many :categories
  has_many :orders

  scope :order_by_column, ->(column){order(column)}
  scope :select_store_id_and_name_and_address, ->{select :id, :name, :address, :image}
  scope :store_active, ->{where status: true}
  scope :store_lock, ->{where is_lock: false}

  STORE_PARAMS = %i(name address short_description description image).freeze

  mount_uploader :image, PictureUploader
  validates :name, presence: true
  validates :address, presence: true
  validates :user_id, presence: true
  validates :short_description, presence: true,
    length: {maximum: Settings.validates.store.short_description_max}
  validate :image_size

  def lock_store
    update is_lock: true
  end

  def unlock_store
    update is_lock: false
  end

  private

  def image_size
    errors.add :image, t("store.validate_image_size") if image.size > Settings.validates.store.image_size.megabytes
  end
end
