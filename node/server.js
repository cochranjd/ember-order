var app = require('express')();
var server = require('http').Server(app);
var io = require('socket.io')(server);
var redis = require( 'redis' ).createClient();

var port = 3001;

server.listen(port);
console.log( 'Ember Order Node Server' );
console.log( '  listening on port[' + port + ']' );

redis.on( 'connect', function() {
  console.log( '  ** Connected to REDIS' );
});

redis.on( 'ready', function() {
  console.log( '  ** Ready for REDIS communication' );
});

var containers = [];

redis.on( 'message', function( channel, message ) {

  var obj = JSON.parse( message ).data;

  if ( !containers[ obj.container_id ] ) {
    containers[ obj.container_id ] = { participants: [] };
  }

  var container = containers[ obj.container_id ];

  var found = false;

  for ( var i=0; i<container.participants.length; i++ ) {
    var participant = container.participants[i];

    if ( participant.email === obj.email ) {
      found = true;
      participant.status = obj.status;
      break;
    }
  }

  if ( !found ) {
    container.participants.push({
      email: obj.email,
      status: obj.status
    });
  }

  console.log( '************************************' );
  console.log( '   Broadcasting to -> ' + obj.container_id );
  console.log( '   %j', container );
  console.log( '************************************' );

  io.to( obj.container_id ).emit( 'order.status', container );
});

redis.subscribe( 'orderStatusUpdate' );
redis.subscribe( 'orderCreate' );

io.on('connection', function (socket) {

  var container = null;

  socket.on( 'order.join-room', function( data, callback ) {
      container = data.container_id;
      joinRoom( socket, container );
      if ( callback ) {
        callback( containers[container] );
      }
  });
});

function joinRoom( socket, room ) {
    socket.join( room );
}


//https://gist.github.com/crabasa/2896891