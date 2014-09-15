import Ember from 'ember';

export default Ember.Controller.extend({

    isGroup: false,

    email: null,

    orderPassword: null,

    associatedOrderCount: 2,

    associatedOrdersList: Ember.A(),

    initOrders: function() {
        var list = this.get( 'associatedOrdersList' ),
            count = this.get( 'associatedOrderCount' );

        for ( var i=0; i<count; i++ ) {
            this.addOrderEntry();
        }
    }.on( 'init' ),

    updateOrders: function() {
        var list = this.get( 'associatedOrdersList' ),
            count = parseInt( this.get( 'associatedOrderCount' ), 10 );

        if ( list.length > count ) {
            this.set( 'associatedOrdersList', list.slice( 0, count ));
        } else if ( list.length < count ) {
            var needed = count - list.length;

            for ( var i=0; i<needed; i++ ) {
                this.addOrderEntry();
            }
        }
    }.observes( 'associatedOrderCount' ),

    addOrderEntry: function() {
        this.get( 'associatedOrdersList' ).pushObject( Ember.Object.create({
            email: null
        }));
    },

    invitees: function() {
        var recordCount = parseInt( this.get( 'associatedOrderCount' ), 10 );

        return this.get( 'associatedOrdersList' ).
                    mapBy( 'email' ).
                    join( ',' );
    }.property( 'associatedOrdersList', 'associatedOrdersList.@each' ),

    actions: {

        startOrder: function() {

            var model = this.store.createRecord( 'order', {
                email: this.get( 'email' ),
                invitees: this.get( 'invitees' )
            });

            model.save().then( function( response ) {
                this.transitionToRoute( 'orders.order', response );
            }.bind( this ));

        },

        /**
         * This is for DEBUG only
         **/
        populate: function() {
            this.setProperties({
                email: 'ember-order@gmail.com',
                isGroup: true
            });
            this.get( 'associatedOrdersList' )[0].set( 'email', 'joe@gmail.com' );
            this.get( 'associatedOrdersList' )[1].set( 'email', 'jack@gmail.com' );
        }

    }

});