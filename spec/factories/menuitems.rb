# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :menuitem do
    title {Faker::Lorem.sentence(2)}
    description {Faker::Lorem.sentence(8)}
    price_in_cents {rand(200..1000)}
  end
end
