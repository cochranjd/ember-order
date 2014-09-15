import Ember from 'ember';

export default Ember.Component.extend({

   count: 0,

   actions: {
       countDown: function() {
           var countVal = parseInt( this.get( 'count' ), 10 );
           this.set( 'count', countVal - 1 );
       },

       countUp: function() {
           var countVal = parseInt( this.get( 'count' ), 10 );
           this.set( 'count', countVal + 1 );
       }
   }

});