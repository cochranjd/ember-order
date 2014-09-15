import DS from 'ember-data';
import Ember from 'ember';

var attr = DS.attr,
    hasMany = DS.hasMany;

export default DS.Model.extend({

    email: attr(),

    token: attr(),

    invitees: attr(),

    status: attr(),

    container_id: attr(),

    total_price_in_cents: attr(),

    cc_number: attr(),

    cc_expire: attr(),

    cc_name: attr(),

    is_paid: attr(),

    menuitems: hasMany( 'menuitem', {
        inverse: 'orders',
        async: true
    }),

    isValid: function() {
        var valid = true;

        valid = valid && !Ember.isBlank( this.get( 'cc_number' ));
        valid = valid && !Ember.isBlank( this.get( 'cc_expire' ));
        valid = valid && !Ember.isBlank( this.get( 'cc_name' ));
    }

});