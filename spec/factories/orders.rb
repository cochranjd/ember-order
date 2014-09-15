# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order do |f|
    f.email {Faker::Internet.email}
    f.token {SecureRandom.hex}
    f.invitees nil
    f.total_price_in_cents 0
    f.status "INIT"
    cc_number nil
    cc_expire nil
    cc_name nil
    is_paid false
  end
end
