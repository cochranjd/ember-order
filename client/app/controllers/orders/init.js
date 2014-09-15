import Ember from 'ember';

export default Ember.ObjectController.extend({

    actions: {

        beginOrder: function() {
            this.set( 'model.status', 'OPEN' );
            this.get( 'model' ).save().then( function( response ) {
                this.transitionToRoute( 'orders.order', response );
            }.bind( this ));
        },

        declineOrder: function() {
            this.set( 'model.status', 'DECLINED' );
            this.get( 'model' ).save().then( function() {
                this.transitionToRoute( 'orders/declined' );
            }.bind( this ));
        }

    }

});