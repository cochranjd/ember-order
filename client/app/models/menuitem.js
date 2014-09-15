import DS from 'ember-data';

var attr = DS.attr,
    hasMany = DS.hasMany;

export default DS.Model.extend({

    title: attr(),

    description: attr(),

    image_url: attr(),

    price_in_cents: attr(),

    orders: hasMany( 'orders', {
        inverse: 'menuitems'
    })

});