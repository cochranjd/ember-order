import Ember from 'ember';

var statusMap = {
    'INIT': { percent: 25, background: '#FF2600' },
    'OPEN': { percent: 50, background: '#FC5B3F' },
    'SELECTED': { percent: 75, background: '#F88B78' },
    'COMPLETED': { percent: 100, background: '#FFC1B7' },
    'DECLINED': { percent: 100, background: '#F6F6F6' }
};

export default Ember.Component.extend({

    order: null,

    classNameBindings: [ ':order-status', 'isFinalized', ':row' ],

    isFinalized: function() {
        return statusMap[this.get( 'order.status' )].percent === 100;
    }.property( 'order', 'order.status' ),

    spanStyle: function() {
        var status = statusMap[this.get( 'order.status' )];
        return 'width: ' + status.percent + '%; background-color: ' + status.background;
    }.property( 'order', 'order.status' )

});