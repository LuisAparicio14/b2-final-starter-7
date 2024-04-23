require 'rails_helper'

RSpec.describe Coupon, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name)}
    it { should validate_presence_of(:code)}
    it { should validate_presence_of(:discount_amount)}
    it { should validate_presence_of(:discount_type)}
    it { should validate_presence_of(:status)}
  end

  describe 'relationships' do
    it {should belong_to(:merchant)}
  end

  describe 'instance methods' do
  end
end