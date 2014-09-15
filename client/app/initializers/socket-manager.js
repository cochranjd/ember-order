export default {

    name: 'socketManager',

    initialize: function( container, application ) {
        application.register( 'socketManager:main', window.socket, { instantiate: false });
        application.inject( 'controller', 'socket', 'socketManager:main' );
        application.inject( 'route', 'socket', 'socketManager:main' );
    }

};