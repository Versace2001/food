class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :meal
  validates :booking_date, presence: true
end
