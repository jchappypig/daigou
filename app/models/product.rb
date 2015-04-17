class Product < ActiveRecord::Base
  validates :name, presence: true

  scope :with_name, ->(name = nil) { name.present? ?  where('name ILIKE ?', "%#{name.gsub(' ','%')}%") : self.all }
end