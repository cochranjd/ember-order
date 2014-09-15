import Ember from 'ember';
import Resolver from 'ember/resolver';
import loadInitializers from 'ember/load-initializers';

Ember.MODEL_FACTORY_INJECTIONS = true;

var App = Ember.Application.extend({
  modulePrefix: 'client', // TODO: loaded via config
  Resolver: Resolver
});

Ember.$( document ).ajaxSend( function( e, xhr ) {
    var token = Ember.$( "meta[name='csrf-token']" ).attr( 'content' );
    xhr.setRequestHeader( 'X-CSRF-TOKEN', token );
});

loadInitializers(App, 'client');

export default App;
