class Product < ActiveRecord::Base
  validates :name, presence: true

  scope :with_name, ->(name = nil) { name.present? ?  where('name ILIKE ?', "%#{name.gsub(' ','%')}%") : self.all }

  def self.empty_selection
    OpenStruct.new(id: nil, name: '')
  end
end