import Ember from 'ember';

export default Ember.ArrayController.extend({

    order: null,

    joined: false,

    itemController: 'status',

    isComplete: function() {
        var model = this.get( 'model' );

        if ( !Ember.isBlank( model )) {
            var allOrdersComplete = model.every( function( item ) {
                return ( item.status === 'DECLINED' || item.status === 'COMPLETED' );
            });

            return allOrdersComplete;
        }

        return false;
    }.property( 'model' ),

    joinOrder: function() {
        if ( this.get( 'order' ) && !this.get( 'connected' )) {

            this.get( 'socket' ).emit( 'order.join-room', {
                container_id: this.get( 'order.container_id' )
            }, function( response ) {
                this.set( 'model', response.participants );
            }.bind( this ));

            this.get( 'socket' ).on( 'order.status', function( response ) {
                this.set( 'model', response.participants );
            }.bind( this ));

            this.set( 'joined', true );
        }
    }.observes( 'order' ),

    checkForCompletion: function() {
        if ( this.get( 'isComplete' )) {
            this.send( 'orderComplete' );
        }
    }.observes( 'isComplete' )

});