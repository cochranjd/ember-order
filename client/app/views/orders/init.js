import Ember from 'ember';

export default Ember.View.extend({

    classNames: [ 'orders-init-page' ],

    addTopLevelClass: function() {
        Ember.$( '.ember-container' ).addClass( 'init-page-active' );
    }.on( 'didInsertElement' ),

    removeTopLevelClass: function() {
        Ember.$( '.ember-container' ).removeClass( 'init-page-active' );
    }.on( 'willDestroyElement' )

});