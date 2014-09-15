object false
node :menuitems do
    @menuitems.map do |item|
        {:id => item.id, :title => item.title, :description => item.description, :price_in_cents => item.price_in_cents}
    end
end