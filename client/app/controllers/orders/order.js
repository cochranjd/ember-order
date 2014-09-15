import Ember from 'ember';

export default Ember.ObjectController.extend({

  needs: [ 'menu/list' ],

  menulist: Ember.computed.alias( 'controllers.menu/list' ),

  totalPrice: function() {
    var map = this.get( 'model.menuitems' ).mapBy( 'price_in_cents' );

    if ( map && map.length > 0 ) {
      return map.reduce( function( total, item ) {
        return total + item;
      });
    }

    return 0;
  }.property( 'model', 'model.menuitems', 'model.menuitems.@each' ),

  actions: {

    selectMenuItem: function( item ){
      var items = this.get( 'model.menuitems' );

      if ( !items.contains( item )) {
        items.pushObject( item );
      } else {
        this.send( 'removeMenuItem', item );
      }
    },

    removeMenuItem: function( item ) {
      var items = this.get( 'model.menuitems' );

      if ( items.contains( item )) {
        items.removeObject( item );
      }
    },

    checkout: function() {
      this.get( 'model' ).save().then( function( response ) {
        this.transitionToRoute( 'orders.checkout', response );
      }.bind( this ));
    }
  }

});