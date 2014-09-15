unless Rails.env.test?
    $redis = Redis.new

    ActiveSupport::Notifications.subscribe "orderStatusUpdate" do |name, start, finish, id, payload|
        $redis.publish( "orderStatusUpdate", payload.to_json )
    end

end