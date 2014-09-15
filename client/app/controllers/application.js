import Ember from 'ember';

export default Ember.Controller.extend({

    setupSocketListener: function() {
        this.get( 'socket' ).on( 'update-status', function( data ) {
            console.log( 'Status Update' );
            console.log( 'Data: ' + data );
        });
    }.on( 'init' )

});