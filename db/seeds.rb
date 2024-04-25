# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Rake::Task["csv_load:all"].invoke


@coupon_1 = Coupon.create!(name: "Discount of 20", code: "Discount20", discount_amount: 20, discount_type: 0, status: 0, merchant_id: 1)
@coupon_2 = Coupon.create!(name: "Discount of 40", code: "Discount40", discount_amount: 40, discount_type: 0, status: 0, merchant_id: 1)
@coupon_3 = Coupon.create!(name: "Discount of 60", code: "Discount60", discount_amount: 60, discount_type: 0, status: 0, merchant_id: 1)
@coupon_4 = Coupon.create!(name: "Discount of 50", code: "Discount50", discount_amount: 50, discount_type: 1, status: 1, merchant_id: 1)
@coupon_5 = Coupon.create!(name: "Discount of 35", code: "Discount35", discount_amount: 35, discount_type: 1, status: 1, merchant_id: 1)
@coupon_6 = Coupon.create!(name: "Discount of 45", code: "Discount45", discount_amount: 45, discount_type: 1, status: 1, merchant_id: 1)