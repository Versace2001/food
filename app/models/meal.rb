class Meal < ApplicationRecord
  belongs_to :user
  has_many :bookings, dependent: :destroy
  validates :description, presence: true
  validates :name, presence: true
  validates :category, presence: true, inclusion: { in: ['Plat', 'Dessert', 'Patisserie', 'Epice', 'Bio'] }
  validates :price, presence: true, numericality: { only_integer: true }
end
