import Ember from 'ember';

export default Ember.ObjectController.extend({

    needs: [ 'statuses' ],

    payment: null,

    actions: {

        submitPayment: function() {
            var payment = this.get( 'payment' );

            this.get( 'model' ).setProperties( payment.getProperties( Ember.keys( payment )));
            this.get( 'model' ).save().then( function( response ) {
                if ( response.get( 'is_paid' )) {
                    if ( this.get( 'controllers.statuses.isComplete' )) {
                        this.send( 'orderComplete' );
                    } else {
                        this.transitionToRoute( 'orders.confirm', response );
                    }
                }
            }.bind( this ));
        }

    }

});