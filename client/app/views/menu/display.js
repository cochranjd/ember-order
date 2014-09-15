import Ember from 'ember';

export default Ember.View.extend({

    classNameBindings: [ ':menu-item', 'isSelected' ],

    isSelected: Ember.computed.alias( 'controller.isSelected' )

});