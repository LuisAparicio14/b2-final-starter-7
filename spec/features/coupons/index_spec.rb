require 'rails_helper'

RSpec.describe 'coupons#index', type: :feature do
  before(:each) do
    @merchant1 = Merchant.create!(name: "Hair Care")

    @coupon_1 = Coupon.create!(name: "Discount of 20", code: "Discount20", discount_amount: 20, discount_type: 0, status: 0, merchant_id: @merchant1.id)
    @coupon_2 = Coupon.create!(name: "Discount of 40", code: "Discount40", discount_amount: 40, discount_type: 0, status: 0, merchant_id: @merchant1.id)
    @coupon_3 = Coupon.create!(name: "Discount of 60", code: "Discount60", discount_amount: 60, discount_type: 0, status: 0, merchant_id: @merchant1.id)
    @coupon_4 = Coupon.create!(name: "Discount of 50", code: "Discount50", discount_amount: 50, discount_type: 0, status: 1, merchant_id: @merchant1.id)
    @coupon_5 = Coupon.create!(name: "Discount of 35", code: "Discount35", discount_amount: 35, discount_type: 0, status: 1, merchant_id: @merchant1.id)
    @coupon_6 = Coupon.create!(name: "Discount of 45", code: "Discount45", discount_amount: 45, discount_type: 0, status: 1, merchant_id: @merchant1.id)


    @customer_1 = Customer.create!(first_name: "Joey", last_name: "Smith")
    @customer_2 = Customer.create!(first_name: "Cecilia", last_name: "Jones")
    @customer_3 = Customer.create!(first_name: "Mariah", last_name: "Carrey")
    @customer_4 = Customer.create!(first_name: "Leigh Ann", last_name: "Bron")
    @customer_5 = Customer.create!(first_name: "Sylvester", last_name: "Nader")
    @customer_6 = Customer.create!(first_name: "Herber", last_name: "Kuhn")

    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, coupon_id: @coupon_1.id)
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2)
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
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 0)
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

  # 2. Merchant Coupon Create 
  it "can create a new coupon" do
    # As a merchant
    # When I visit my coupon index page 
    visit merchant_coupons_path(@merchant1)
    # I see a link to create a new coupon.
    expect(page).to have_content("Create New Coupon")
    # When I click that link 
    click_link("Create New Coupon")
    # I am taken to a new page where I see a form to add a new coupon.
    expect(current_path).to eq(new_merchant_coupon_path(@merchant1))
    expect(page).to have_content("Create a New Coupon")
    within '.new_coupon' do
      expect(page).to have_content("Name:")
      expect(page).to have_field(:name)
      expect(page).to have_content("Code:")
      expect(page).to have_field(:code)
      expect(page).to have_content("Discount Amount:")
      expect(page).to have_field(:discount_amount)
      expect(page).to have_content("Dollars $")
      expect(page).to have_content("Percentage %")
      expect(page).to have_unchecked_field(:discount_type)        
      expect(page).to have_button("Create Coupon")
    end
    within '.new_coupon' do
      # When I fill in that form with a name, unique code, an amount, and whether that amount is a percent or a dollar amount
      fill_in :name, with: "New code"
      fill_in :code, with: "37727742"
      fill_in :discount_amount, with: 25
      choose :discount_type_dollar
      # And click the Submit button
      click_button "Create Coupon" 
    end
    # I'm taken back to the coupon index page 
    expect(current_path).to eq(merchant_coupons_path(@merchant1))
    # And I can see my new coupon listed.
    expect(page).to have_content("New code")
    expect(page).to have_content("37727742")

  end
  
  # * Sad Paths to consider: 
  # 1. This Merchant already has 5 active coupons
  it "shows an error message when trying to create more than the maximum allowed coupons" do
    merchant = Merchant.create!(name: "Hair Care")
    5.times do |n|
      merchant.coupons.create!(name: "Coupon #{n + 1}", code: "CODE#{n + 1}", discount_amount: 10, discount_type: 0, status: 0)
    end
    visit merchant_coupons_path(merchant)
    
    click_link 'Create New Coupon'
    within '.new_coupon' do
      fill_in 'Name:', with: 'Sixth Coupon'
      fill_in 'Code:', with: 'CODE6'
      fill_in 'Discount Amount:', with: 30
      choose :discount_type_dollar
      click_button 'Create Coupon'
    end
  end


  # 2. Coupon code entered is NOT unique
  it "not unique code" do
    visit merchant_coupons_path(@merchant1)

    click_link 'Create New Coupon'
    within '.new_coupon' do
      fill_in 'Name:', with: 'Duplicate Coupon'
      fill_in 'Code:', with: 'Discount20'  # Duplicate code
      fill_in 'Discount Amount:', with: 25
      choose :discount_type_percent
      click_button 'Create Coupon'
    end
  end

  # 6. Merchant Coupon Index Sorted
  it "" do
    # As a merchant
    # When I visit my coupon index page
    visit merchant_coupons_path(@merchant1)
    # I can see that my coupons are separated between active and inactive coupons.
    within '.Active' do
      expect(page).to have_content("Active Coupons:")
      expect(page).to have_content("Name: Discount of 20")
      expect(page).to have_content("Name: Discount of 40")
      expect(page).to have_content("Name: Discount of 60")
    end

    within '.Inactive' do
      expect(page).to have_content("Inactive Coupons:")
      expect(page).to have_content("Name: Discount of 50")
      expect(page).to have_content("Name: Discount of 35")
      expect(page).to have_content("Name: Discount of 45")
    end
  end
end