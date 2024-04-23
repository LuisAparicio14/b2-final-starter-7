class Coupon < ApplicationRecord
  validates :name, presence: true
  validates :code, presence: true, uniqueness: true
  validates :discount_amount, presence: true
  validates :discount_type, presence: true
  validates :status, presence: true


  validates_uniqueness_of :code

  belongs_to :merchant

  enum status: [:active, :deactive]
  enum discount_type: [:percent, :dollar]
end