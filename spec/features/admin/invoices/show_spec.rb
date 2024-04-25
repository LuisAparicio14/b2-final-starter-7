require "rails_helper"

describe "Admin Invoices Index Page" do
  before :each do
    @m1 = Merchant.create!(name: "Merchant 1")

    @coupon_1 = Coupon.create!(name: "Discount of 20", code: "Discount20", discount_amount: 20, discount_type: 0, status: 0, merchant_id: @m1.id)
    @coupon_2 = Coupon.create!(name: "Discount of 40", code: "Discount15", discount_amount: 40, discount_type: 0, status: 0, merchant_id: @m1.id)
    @coupon_3 = Coupon.create!(name: "Discount of 60", code: "Discount65", discount_amount: 60, discount_type: 0, status: 0, merchant_id: @m1.id)
    @coupon_4 = Coupon.create!(name: "Discount of 50", code: "Discount55", discount_amount: 50, discount_type: 0, status: 1, merchant_id: @m1.id)
    @coupon_5 = Coupon.create!(name: "Discount of 35", code: "Discount33", discount_amount: 35, discount_type: 0, status: 1, merchant_id: @m1.id)
    @coupon_6 = Coupon.create!(name: "Discount of 45", code: "Discount34", discount_amount: 45, discount_type: 0, status: 1, merchant_id: @m1.id)

    @c1 = Customer.create!(first_name: "Yo", last_name: "Yoz", address: "123 Heyyo", city: "Whoville", state: "CO", zip: 12345)
    @c2 = Customer.create!(first_name: "Hey", last_name: "Heyz")

    @i1 = Invoice.create!(customer_id: @c1.id, status: 2, created_at: "2012-03-25 09:54:09", coupon_id: @coupon_1.id)
    @i2 = Invoice.create!(customer_id: @c2.id, status: 1, created_at: "2012-03-25 09:30:09", coupon_id: @coupon_2.id)

    @item_1 = Item.create!(name: "test", description: "lalala", unit_price: 6, merchant_id: @m1.id)
    @item_2 = Item.create!(name: "rest", description: "dont test me", unit_price: 12, merchant_id: @m1.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_1.id, quantity: 122, unit_price: 2, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_2.id, quantity: 6, unit_price: 1, status: 1)
    @ii_3 = InvoiceItem.create!(invoice_id: @i2.id, item_id: @item_2.id, quantity: 87, unit_price: 12, status: 2)

    visit admin_invoice_path(@i1)
  end

  it "should display the id, status and created_at" do
    expect(page).to have_content("Invoice ##{@i1.id}")
    expect(page).to have_content("Created on: #{@i1.created_at.strftime("%A, %B %d, %Y")}")

    expect(page).to_not have_content("Invoice ##{@i2.id}")
  end

  it "should display the customers name and shipping address" do
    expect(page).to have_content("#{@c1.first_name} #{@c1.last_name}")
    expect(page).to have_content(@c1.address)
    expect(page).to have_content("#{@c1.city}, #{@c1.state} #{@c1.zip}")

    expect(page).to_not have_content("#{@c2.first_name} #{@c2.last_name}")
  end

  it "should display all the items on the invoice" do
    expect(page).to have_content(@item_1.name)
    expect(page).to have_content(@item_2.name)

    expect(page).to have_content(@ii_1.quantity)
    expect(page).to have_content(@ii_2.quantity)

    expect(page).to have_content("$#{@ii_1.unit_price}")
    expect(page).to have_content("$#{@ii_2.unit_price}")

    expect(page).to have_content(@ii_1.status)
    expect(page).to have_content(@ii_2.status)

    expect(page).to_not have_content(@ii_3.quantity)
    expect(page).to_not have_content("$#{@ii_3.unit_price}")
    expect(page).to_not have_content(@ii_3.status)
  end

  it "should display the total revenue the invoice will generate" do
    expect(page).to have_content("Total Revenue: $#{@i1.total_revenue}")

    expect(page).to_not have_content(@i2.total_revenue)
  end

  it "should have status as a select field that updates the invoices status" do
    within("#status-update-#{@i1.id}") do
      select("cancelled", :from => "invoice[status]")
      expect(page).to have_button("Update Invoice")
      click_button "Update Invoice"

      expect(current_path).to eq(admin_invoice_path(@i1))
      expect(@i1.status).to eq("completed")
    end
  end

  # 8. Admin Invoice Show Page: Subtotal and Grand Total Revenues
  it "subtotal and grand total for admin" do
    # As an admin
    # When I visit one of my admin invoice show pages
    visit admin_invoice_path(@i1)
    # I see the name and code of the coupon that was used (if there was a coupon applied)
    # And I see both the subtotal revenue from that invoice (before coupon) and the grand total revenue (after coupon) for this invoice.
    within '.invoice_coupons' do
      expect(page).to have_content(@coupon_1.name)
      expect(page).to have_content(@coupon_1.code)
      expect(page).to have_content("Total Revenue: $250.00")
      expect(page).to have_content("Grand Total: $2.00") #20% off
    end
  end
end
