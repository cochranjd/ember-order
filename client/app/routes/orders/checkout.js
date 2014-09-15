import Ember from 'ember';

export default Ember.Route.extend({

    setupController: function( controller, model ) {
        model = this.modelFor( 'orders' );

        controller.set( 'model', model );
        controller.set( 'payment', Ember.Object.create({
            cc_number: null,
            cc_expire: null,
            cc_name: null

        }));
    }

});