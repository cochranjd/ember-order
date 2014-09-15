import Ember from 'ember';

export default Ember.Route.extend({

    actions: {

        orderComplete: function() {
            this.transitionTo( 'orders/completed' );
        },

        getOrderInfo: function( order ) {
            Ember.$.ajax({
                type: 'GET',
                url: '/api/info/' + order.get( 'id' )
            }).done( function( response ) {
                var orders = [];

                for ( var i=0; i<response.length; i++ ) {
                    orders.pushObject( Ember.Object.create({
                        email: response[i].order.email,
                        token: response[i].order.token,
                        status: response[i].order.status
                    }));
                }

                this.controllerFor( 'debuginfo' ).set( 'model', orders );
                Ember.$( '#debugModal' ).foundation( 'reveal', 'open' );
            }.bind( this ));
        },

        openOrder: function( order ) {
            window.open( 'http://localhost:3000/orders/' + order.token + '/init', '_blank' );
            Ember.$( '#debugModal' ).foundation( 'reveal', 'close' );
        }

    }

});