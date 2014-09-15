# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Menuitem.create(:title => 'Sandwich', :description => 'A delicous sandwich', :price_in_cents => 865)
Menuitem.create(:title => 'Soup', :description => 'A nice bowl of soup', :price_in_cents => 865)
Menuitem.create(:title => 'Cheeseburger', :description => 'A scrumptious cheeseburger', :price_in_cents => 865)
Menuitem.create(:title => 'Pizza', :description => 'A pizza pie for you', :price_in_cents => 865)
Menuitem.create(:title => 'Chili', :description => 'Hot, steaming chili', :price_in_cents => 865)
Menuitem.create(:title => 'Taco', :description => 'Enjoy a crispy taco', :price_in_cents => 865)
Menuitem.create(:title => 'Salad', :description => 'For the calorie concious', :price_in_cents => 865)
Menuitem.create(:title => 'Steak', :description => 'Steak.  Enough said', :price_in_cents => 865)
Menuitem.create(:title => 'Chicken', :description => 'MMMMMMMMM Chicken.', :price_in_cents => 865)