class Coupon < ApplicationRecord
  validates_presence_of :name,
                        :code,
                        :discount_amount,
                        :discount_type,
                        :status

  validates_uniqueness_of :code

  belongs_to :merchant

  enum status: [:active, :deactive]

end