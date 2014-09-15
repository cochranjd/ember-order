require 'rails_helper'

describe "Api::Orders", :type => :request do
    before { ActionMailer::Base.deliveries = [] }

    it 'Should accept POST to /api/orders' do
        params = {
            order: {
                id: nil,
                email: 'josh.cochran@gmail.com',
                token: nil,
                invitees: 'anna@gmail.com,josh@gmail.com',
                payment: nil
            }
        }

        post '/api/orders', params, format: :json

        expect(response).to be_success
        expect(json['order']['token']).not_to be_nil
    end

    it 'Should send e-mails to each invitee' do
        params = {
            order: {
                id: nil,
                email: 'josh.cochran@gmail.com',
                token: nil,
                invitees: 'anna@gmail.com,josh@gmail.com'
            }
        }

        post '/api/orders', params, format: :json

        email_count = ActionMailer::Base.deliveries.length
        expect(email_count).to eq(2)

        email_to_josh = ActionMailer::Base.deliveries.find_all { |email| email['to'].to_s == 'josh@gmail.com' }
        expect(email_to_josh.count).to eq(1)

        email_to_anna = ActionMailer::Base.deliveries.find_all { |email| email['to'].to_s == 'anna@gmail.com' }
        expect(email_to_anna.count).to eq(1)
    end

    it 'Should allow put requests to set ordered items' do
        order = FactoryGirl.create(:order, invitees: [Faker::Internet.email, Faker::Internet.email].join(','))
        items = FactoryGirl.create_list(:menuitem, 3)

        params = {
            order: {
                id: order.id,
                container_id: order.container_id,
                email: order.email,
                token: order.token,
                invitees: order.invitees,
                menuitems: items.collect(&:id)
            }
        }

        put "/api/orders/#{order.token}", params, format: :json

        expect(response).to be_success
        expect(json['order']['menuitem_ids'].length).to eq(3)
    end

    it 'Should update total_price_in_cents when order items are added' do
        order = FactoryGirl.create(:order, invitees: [Faker::Internet.email, Faker::Internet.email].join(','))
        items = FactoryGirl.create_list(:menuitem, 3)

        params = {
            order: {
                id: order.id,
                container_id: order.container_id,
                email: order.email,
                token: order.token,
                invitees: order.invitees,
                menuitems: items.collect(&:id)
            }
        }

        put "/api/orders/#{order.token}", params, format: :json

        expect(response).to be_success
        expect(json['order']['menuitem_ids'].length).to eq(3)
        expect(json['order']['total_price_in_cents']).to eq(items.collect(&:price_in_cents).inject{|sum,x| sum + x})
    end

    it 'Should change status to SELECTED when order items are set' do
        order = FactoryGirl.create(:order, invitees: [Faker::Internet.email, Faker::Internet.email].join(','))
        items = FactoryGirl.create_list(:menuitem, 3)

        params = {
            order: {
                id: order.id,
                container_id: order.container_id,
                email: order.email,
                token: order.token,
                invitees: order.invitees,
                menuitems: items.collect(&:id)
            }
        }

        put "/api/orders/#{order.token}", params, format: :json

        expect(response).to be_success
        expect(json['order']['status']).to eq('SELECTED')
    end

    it 'Should error when an invalid token is used' do
        order = FactoryGirl.create(:order, invitees: [Faker::Internet.email, Faker::Internet.email].join(','))
        items = FactoryGirl.create_list(:menuitem, 3)

        params = {
            order: {
                id: order.id,
                container_id: order.container_id,
                email: order.email,
                token: order.token,
                invitees: order.invitees,
                menuitems: items.collect(&:id)
            }
        }

        put "/api/orders/1111", params, format: :json

        expect(response).not_to be_success
    end

    it 'Should allow user to move status from INIT to OPEN' do
        order = FactoryGirl.create(:order)

        params = {
            order: {
                id: order.id,
                container_id: order.container_id,
                email: order.email,
                token: order.token,
                invitees: nil,
                status: 'OPEN',
                menuitems: nil
            }
        }

        put "/api/orders/#{order.token}", params, format: :json
        get "/api/orders/#{order.token}", format: :json

        expect(json['order']['status']).to eq('OPEN')
    end

    it 'Should allow user to move status from INIT to DECLINED' do
        order = FactoryGirl.create(:order)

        params = {
            order: {
                id: order.id,
                container_id: order.container_id,
                email: order.email,
                token: order.token,
                invitees: nil,
                status: 'DECLINED',
                menuitems: nil
            }
        }

        put "/api/orders/#{order.token}", params, format: :json
        get "/api/orders/#{order.token}", format: :json

        expect(json['order']['status']).to eq('DECLINED')
    end

    it 'Should publish a message when status is changed to OPEN' do
        order = FactoryGirl.create(:order)
        notification_count = 0
        last_notification = nil

        params = {
            order: {
                id: order.id,
                container_id: order.container_id,
                email: order.email,
                token: order.token,
                invitees: nil,
                status: 'OPEN',
                menuitems: nil
            }
        }

        ActiveSupport::Notifications.subscribe "orderStatusUpdate" do |name, start, finish, id, payload|
            notification_count += 1
            last_notification = payload
        end

        put "/api/orders/#{order.token}", params, format: :json

        expect(notification_count).to eq(1)
        expect(last_notification[:data][:email]).to eq(order.email)
        expect(last_notification[:data][:status]).to eq('OPEN')
    end

    it 'Should publish a message when status is changed to SELECTED' do
        order = FactoryGirl.create(:order, invitees: [Faker::Internet.email, Faker::Internet.email].join(','))
        items = FactoryGirl.create_list(:menuitem, 3)

        notification_count = 0
        last_notification = nil

        ActiveSupport::Notifications.subscribe "orderStatusUpdate" do |name, start, finish, id, payload|
            notification_count += 1
            last_notification = payload
        end

        params = {
            order: {
                id: order.id,
                container_id: order.container_id,
                email: order.email,
                token: order.token,
                invitees: order.invitees,
                menuitems: items.collect(&:id)
            }
        }

        put "/api/orders/#{order.token}", params, format: :json

         expect(notification_count).to eq(1)
         expect(last_notification[:data][:email]).to eq(order.email)
         expect(last_notification[:data][:status]).to eq('SELECTED')
    end
end