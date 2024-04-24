require 'rails_helper'

RSpec.describe 'coupon#show', type: :feature do
  before(:each) do
    @merchant1 = Merchant.create!(name: "Hair Care")

    @coupon_1 = Coupon.create!(name: "Discount of 20", code: "Discount20", discount_amount: 20, discount_type: 0, status: 0, merchant_id: @merchant1.id)
    @coupon_2 = Coupon.create!(name: "Discount of 40", code: "Discount40", discount_amount: 40, discount_type: 0, status: 1, merchant_id: @merchant1.id)
    @coupon_3 = Coupon.create!(name: "Discount of 60", code: "Discount60", discount_amount: 60, discount_type: 0, status: 0, merchant_id: @merchant1.id)
    @coupon_4 = Coupon.create!(name: "Discount of 50", code: "Discount50", discount_amount: 60, discount_type: 0, status: 1, merchant_id: @merchant1.id)


    @customer_1 = Customer.create!(first_name: "Joey", last_name: "Smith")
    @customer_2 = Customer.create!(first_name: "Cecilia", last_name: "Jones")
    @customer_3 = Customer.create!(first_name: "Mariah", last_name: "Carrey")
    @customer_4 = Customer.create!(first_name: "Leigh Ann", last_name: "Bron")
    @customer_5 = Customer.create!(first_name: "Sylvester", last_name: "Nader")
    @customer_6 = Customer.create!(first_name: "Herber", last_name: "Kuhn")

    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, coupon_id: @coupon_1.id)
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2, coupon_id: @coupon_3.id)
    @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
    @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2)
    @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2)
    @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
    @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 1, coupon_id: @coupon_2.id)

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
    @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
    @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 0)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_5 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)

    @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
    @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_3.id)
    @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_4.id)
    @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_5.id)
    @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_6.id)
    @transaction6 = Transaction.create!(credit_card_number: 879799, result: 1, invoice_id: @invoice_7.id)
    @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_2.id)
  end

  # 3. Merchant Coupon Show Page 
  it "coupon show page" do
    # As a merchant 
    # When I visit a merchant's coupon show page 
    visit merchant_coupon_path(@merchant1, @coupon_1)
    # I see that coupon's name and code 
    expect(page).to have_content("Name: Discount of 20")
    expect(page).to have_content("Code: Discount20")
    # And I see the percent/dollar off value
    expect(page).to have_content("Off: 20")
    # As well as its status (active or inactive)
    expect(page).to have_content("Status: active")
    # And I see a count of how many times that coupon has been used.
    expect(page).to have_content("Used: 1")
  end

  # 4. Merchant Coupon Deactivate
  it "has a button to deactivate" do
    # As a merchant 
    # When I visit one of my active coupon's show pages
    visit merchant_coupon_path(@merchant1, @coupon_1)
    # I see a button to deactivate that coupon
    within '.buttons' do
      expect(page).to have_button("Deactivate Coupon")
    end
    # When I click that button
    click_button("Deactivate Coupon")
    # I'm taken back to the coupon show page 
    expect(current_path).to eq(merchant_coupon_path(@merchant1, @coupon_1))
    # And I can see that its status is now listed as 'inactive'.
    expect(page).to have_content("Status: inactive")
  end

  # 5. Merchant Coupon Activate
  it "has a button to activate" do
    # As a merchant 
    # When I visit one of my inactive coupon show pages
    visit merchant_coupon_path(@merchant1, @coupon_4)
    # I see a button to activate that coupon
    within '.buttons' do
      expect(page).to have_button("Activate Coupon")
    end
    # When I click that button
    click_button("Activate Coupon")
    # I'm taken back to the coupon show page 
    expect(current_path).to eq(merchant_coupon_path(@merchant1, @coupon_4))
    # And I can see that its status is now listed as 'active'.
    expect(page).to have_content("Status: active")
  end
end