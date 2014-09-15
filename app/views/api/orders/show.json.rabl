object @order
attributes :id,
           :token,
           :email,
           :status,
           :container_id,
           :total_price_in_cents,
           :cc_number,
           :cc_expire,
           :cc_name,
           :is_paid

node :menuitems do |item|
    item.menuitems.map do |menuitem|
        menuitem.id
    end
end