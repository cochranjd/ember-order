import Ember from 'ember';

export default Ember.ObjectController.extend({

    needs: [ 'orders/order' ],

    isSelected: function() {
        var menuitems = this.get( 'parentController.model.menuitems' );

        if ( !menuitems ) {
            return false;
        }

        return menuitems.contains( this.model );
    }.property( 'parentController.model.menuitems', 'parentController.model.menuitems.@each' )

});