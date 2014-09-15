require 'rails_helper'

describe "Api::Payment", :type => :request do

    it 'Should accept PUT to /api/orders/:token' do
        order = FactoryGirl.create(:order)
        items = FactoryGirl.create_list(:menuitem, 3)
        order.menuitems << items
        order.status = 'SELECTED'
        order.save!

        params = {
            order: {
                id: nil,
                email: order.email,
                token: order.token,
                invitees: 'anna@gmail.com,josh@gmail.com',
                cc_number: Faker::Business.credit_card_number.tr('-',''),
                cc_expire: '%02i/%02i' % [rand(1..12),rand(15..20)],
                cc_name: Faker::Name.name
            }
        }

        put "/api/orders/#{order.token}", params, format: :json

        expect(response).to be_success
        expect(json['order']['is_paid']).to be_truthy
    end

    it 'Should set order status to COMPLETED on PUT' do
        order = FactoryGirl.create(:order)
        items = FactoryGirl.create_list(:menuitem, 3)
        order.menuitems << items
        order.status = 'SELECTED'
        order.save!

        params = {
            order: {
                id: nil,
                email: order.email,
                token: order.token,
                invitees: 'anna@gmail.com,josh@gmail.com',
                cc_number: Faker::Business.credit_card_number.tr('-',''),
                cc_expire: '%02i/%02i' % [rand(1..12),rand(15..20)],
                cc_name: Faker::Name.name
            }
        }

        put "/api/orders/#{order.token}", params, format: :json
        get "/api/orders/#{order.token}", format: :json

        expect(response).to be_success
        expect(json['order']['status']).to eq('COMPLETED')
    end

    it 'Should send a notification when changing status to COMPLETED' do
        order = FactoryGirl.create(:order)
        items = FactoryGirl.create_list(:menuitem, 3)
        order.menuitems << items
        order.status = 'SELECTED'
        order.save!

        params = {
            order: {
                id: nil,
                email: order.email,
                token: order.token,
                invitees: 'anna@gmail.com,josh@gmail.com',
                cc_number: Faker::Business.credit_card_number.tr('-',''),
                cc_expire: '%02i/%02i' % [rand(1..12),rand(15..20)],
                cc_name: Faker::Name.name
            }
        }

        notification_count = 0
        last_notification = nil
        ActiveSupport::Notifications.subscribe "orderStatusUpdate" do |name, start, finish, id, payload|
            notification_count += 1
            last_notification = payload
        end

        put "/api/orders/#{order.token}", params, format: :json

        expect(notification_count).to eq(1)
        expect(last_notification[:data][:email]).to eq(order.email)
        expect(last_notification[:data][:status]).to eq('COMPLETED')
    end
end