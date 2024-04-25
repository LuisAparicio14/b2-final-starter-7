class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  belongs_to :coupon, optional: true

  enum status: [:cancelled, :in_progress, :completed]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def grand_total
    if coupon
      if coupon.discount_type == "percent"
        discount = (coupon.discount_amount.to_f / 100) * total_revenue
      elsif coupon.discount_type == "dollar"
        discount = (coupon.discount_amount * 100)
      else
        discount = 0
      end
    else
      discount = 0
    end
    grand_total = total_revenue - discount
  end
end
# def merchant_subtotal(merchant_id)
#   invoice_items
#     .joins(:item)
#     .where(items: { merchant_id: merchant_id })
#     .sum("invoice_items.unit_price * invoice_items.quantity")
# end
