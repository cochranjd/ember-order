import Ember from 'ember';

export default Ember.Route.extend({

    setupController: function( controller, model ) {
        model = this.modelFor( 'orders' );

        controller.set( 'model', model);
        this.controllerFor( 'menu/list' ).set( 'model', this.store.find( 'menuitem' ));
        this.controllerFor( 'statuses' ).set( 'order', model );
    }

});