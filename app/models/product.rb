class Product < ApplicationRecord
    has_one_attached :image
    has_rich_text :description
    validates :title, :description, :price, presence: true
    validates :price, numericality: { greater_than_or_equal_to: 0 }

    belongs_to :category
end
