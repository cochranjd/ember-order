require 'rails_helper'

RSpec.describe Order, :type => :model do
  before { ActionMailer::Base.deliveries = [] }

  it 'is invalid without an e-mail' do
    expect(FactoryGirl.build(:order, email: nil)).not_to be_valid
  end

  it 'generates a unique token' do
    order = FactoryGirl.build(:order)
    expect(order['token']).not_to be_nil
  end

  it 'sends email when order is created with status of INIT' do
    FactoryGirl.create(:order, invitees: nil)
    expect(ActionMailer::Base.deliveries.length).to eq(1)
  end

  it 'does not send email when order is created with status of OPEN' do
    FactoryGirl.create(:order, invitees: nil, status: 'OPEN')
    expect(ActionMailer::Base.deliveries.length).to eq(0)
  end

  describe "Payment Validation" do
    order = nil

    before (:each) do
      order = FactoryGirl.build(:order)
      order.cc_number = Faker::Business.credit_card_number.tr('-','')
      order.cc_expire = '%02i/%02i' % [rand(1..12),rand(15..20)]
      order.cc_name = Faker::Name.name
    end

    it "Should only set is_paid if cc_number is set" do
      order.cc_number = nil
      order.save!

      expect(order.is_paid).to be_falsy

      order.cc_number = Faker::Business.credit_card_number.tr('-','')
      order.save!
      expect(order.is_paid).to be_truthy
    end

    it "Should only set is_paid if cc_expire is set" do
      order.cc_expire = nil
      order.save!

      expect(order.is_paid).to be_falsy

      order.cc_expire = '%02i/%02i' % [rand(1..12),rand(15..20)]
      order.save!
      expect(order.is_paid).to be_truthy
    end

    it "Should only set is_paid if cc_name is set" do
      order.cc_name = nil
      order.save!

      expect(order.is_paid).to be_falsy

      order.cc_name = Faker::Name.name
      order.save!
      expect(order.is_paid).to be_truthy
    end
  end
end