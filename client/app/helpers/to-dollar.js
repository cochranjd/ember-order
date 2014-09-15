import Ember from 'ember';

export default Ember.Handlebars.makeBoundHelper( function( value ) {
    var dollars = Math.floor( value / 100 ),
        cents = value % 100,
        pad = cents < 10 ? '0':'';

    return '$' + dollars + '.' + pad + cents;
});