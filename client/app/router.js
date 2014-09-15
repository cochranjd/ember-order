import Ember from 'ember';

var Router = Ember.Router.extend({
  location: ClientENV.locationType
});

Router.map(function() {
  this.route( 'placeorder', { path: '/placeorder' });
  this.route( 'orders/init', { path: '/orders/:id/init' });
  this.route( 'orders/completed', { path: '/completed' });
  this.route( 'orders/declined', { path: '/declined' });

  this.resource('orders', { path: 'orders/:id' }, function(){
      this.route( 'order', { path: '/' });
      this.route( 'checkout', { path: '/checkout' });
      this.route( 'confirm', { path: '/confirm' });
  });
});

export default Router;
