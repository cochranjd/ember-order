# Ember-Order

<a href="http://162.243.66.51/placeorder" alt="Live Demo" target="_blank">Live Demo</a>

#### To build locally
 * Make sure you have Ruby, Redis, Node.js & grunt-cli installed
 * After cloning, you'll probably need to go into the _*client*_ folder and run 'npm install && bower install'
 * Ensure _*redis-server*_ is running
 * Run 'grunt' to build the Ember application and embed it into the Rails view architecture
 * Run 'bin/rails s' to start the Rails server
 * Run 'node node/server.js' to start the Node.js server
 * Browse to 'http://localhost:3000/placeorder'
 * *If you make any changes to the Ember application, simply run _grunt_ to rebuild/reinject the application and then restart the Rails server.  To rebuild the development database (this should only be needed if you are changing information on the backend or seed info), run _grunt fresh_*

This application is a simple, collaborative ordering app that I built for presenting to the Ember-Dallas Meetup.com group.  This is not a production ready application and should only be used as a basic example or for learning purposes.

## What this ISN'T

 * A production ready application
 * A thoroughly tested application
 * A Ruby on Rails, Node.js or Socket.IO focused code base
 * The only way to do any of this

Now that we've got that out of the way...

## Basic Architecture

<img src="/docs/architecture.png" alt="Architecture" width="400" style="margin: 0 auto;">

There are 3 major parts of the overall application architecture, along with a few additional pieces to provide communication between the components.  They are:

 * **[EmberJS](http://emberjs.com/)** - Ember.js is the JavaScript framework used for the front end of the application. Ember-Data has been used for the model layer.
 * **[Ruby on Rails](http://rubyonrails.org/)** - The API is supported using Ruby on Rails.  RoR handles all of the application's page & AJAX requests.
 * **[NodeJS](http://nodejs.org/)** - Node.js is used to facilitate real time updates via Socket.IO
 * **[Redis](http://redis.io/)** - Ruby on Rails & Node.js communicate via Redis pub/sub.
 * **[SocketIO](http://socket.io/)** - Socket.IO is used to support real time updates of client status across all participants.

The Ember.js application is built using Ember-CLI along with a build script that takes the Ember-CLI build output and injects it into the Rails application.  It does this by injecting the output [index.html](client/app/index.html) file into the [application/index.html.erb view](app/views/application/index.html.erb).

The Rails application handles serving the Ember code via the view file mentioned before, [application/index.html.erb](app/views/application/index.html.erb).  The Rails server is also responsible for handling all calls to the API, namespaced with the /api path.  Along with handling client requests, the Rails server utilizes [redis-rb](https://github.com/redis/redis-rb) to publish status updates to the REDIS server.

The Node.js application listens for clients to establish connections via Socket.IO at which point it tracks participants in the order and routes status updates to all participants.  The Node.js application receives these status updates via the REDIS server by subscribing to particular messages.


## Walking through the Ember code

**Placeorder**  
[controller](client/app/controllers/placeorder.js)  
[view](client/app/views/placeorder.js)  
[template](client/app/templates/placeorder.hbs)  

The placeorder page is responsible for establishing a new group order.

 * A basic controller is used here to gather all of the data for the order and a model is generated when the user decides to proceed.  Alternatively, you could generate an empty order in the route, use an ObjectController and then set the generated order model onto the controller.
 * When the startOrder event is caught, the controller gathers the order information, generates a new model and sends the model to the server for persisting.
 * Upon receiving the server's response, the user is transitioned to the page for their personal order.

**orders/order**  
[route](client/app/routes/orders/order.js)  
[controller](client/app/controllers/orders/order.js)  
[view](client/app/views/orders/order.js)  
[template](client/app/templates/orders/order.hbs)  

The orders/order page is responsible for handling an individual participant's order.

 * The route grabs the order from the parent route and sets it on the controller.
 * The route also looks up the list of menu items and sets them on the menu/list controller as well as setting the order item on the statuses controller.  You could bind these into a hash and use the model hook, but this would make for more work in transitionTo calls and it is acceptable for this demo if these show up after a slight delay.
 * The controller is given the order object as its model and it appends/removes menu items as selections are made on the page.  The menu items are displayed with their [own controllers](client/app/controllers/menu/display.js) which checks against the selected list of menu items in this controller to detect whether or not the particular item is selected (and should be rendered as such).
 * Since the menu items are attached/detached dynamically, the checkout event simply moves the user to the next page in the process, orders/checkout.

**orders/checkout**  
[route](client/app/routes/orders/checkout.js)  
[controller](client/app/controllers/orders/checkout.js)  
[template](client/app/templates/orders/checkout.hbs)  

The orders/checkout page is responsible for handling and sending payment info to the server.

 * The route grabs the order from the parent route and sets it on the controller.
 * The route also initializes an empty payment model and sets it on the controller as the payment object.
 * The controller simply handles the saving of the payment model to the server when the user clicks the 'Pay Now' button
 * If the response from the server shows that the order is now paid, the controller checks to see if the group order is now complete.  If so, the user is sent to the group order complete page.  If not, the user is sent to the individual order complete page where they can observe the status of the remaining participants.

**orders/init**  
[route](client/app/routes/orders/init.js)  
[controller](client/app/controllers/orders/init.js)  
[view](client/app/views/orders/init.js)  
[template](client/app/templates/orders/init.hbs)  

The orders/init page is responsible for providing an entry point for users that have been invited into the order.  They can accept the invitation or decline and exit the process.

 * The route looks up the order based on the URL.  Since this is NOT set up as a nested route on the order resource, it does NOT look it up on the orders route as many other's do.  This was done since I do not want this particular page to be rendered inside the orders outlet, but I did want a similar path.
 * The controller updates the status of the order, which indicates the user's decision about participation.  They are then transitioned to the appropriate route - the orders/order route for accepted orders and the orders/declined route for those opting out.
 * The view is adding and removing the init-page-active tag to the top level div on DOM insertion/removal.  This is to support the full screen image background since the view itself does not encapsulate the entire page.

**statuses**  
[controller](client/app/controllers/statuses.js)  
[template](client/app/templates/statuses.hbs)  

The statuses widget is used to track the status of all participants involved in the order.

 * Once the order is created, the [orders/order route](client/app/routes/orders/order.js) sets the _order_ attribute on the controller.
 * Once the controller detects an order has been set, it turns around and sends a request to Socket.IO indicating it needs to be made aware of changes to that group order.
 * Socket.IO responds with the current status of the group oder, which is set as the controller's model - an array of user statuses
 * The controller also listens for order status updates, which will only be sent by Socket.IO if there are updates to the status of participants in this group order.  If a message is received, the controller's model is updated.
 * Each time a message is received, the controller checks to see if all statuses are completed (completed simply means the order has either been declined or has been paid for and is done).  Once all orders are completed, the _orderComplete_ event is set, which eventually results in the [application route](client/app/routes/application.js) transitioning the user to a screen to inform them their group order is complete and will be delivered soon.

**application route**  
[route](client/app/routes/application.js)  

I wanted to briefly discuss the application route since there are some non-trivial things happening inside.

 * Since events bubble from view to controller, then to route, then up the route chain, we an use the application route to catch application wide events.  In our case, these events only happen from one place, so we could catch them more locally, but the response to these actions typically is beyond the scope of the particular controller/view that is responsible for sending the message so I handled them in the application route.
 * _orderComplete_ is fired once all statuses register as "complete" in the statuses controller.
 * _getOrderInfo_ THIS IS A DEBUG ONLY FEATURE.  The application is built to send e-mails to invitees, but for live demo purposes, this is disabled.  To allow folks using the live demo to get the order paths of "invitees" and play with the application while not having access to the server to see the simulated invite e-mails go out, I have added a debug modal.  
  * The modal uses a simple AJAX request since I didn't want to have af ull model layer and deal with record caching, which I actually do not want here.
  * The server will take the associated container_id (which all participants share) and find all associated orders.  After stripping out the requesting order, the results are sent back.
  * The modal displays the e-mail &amp; status of each order, providing a link to the actual order page allowing the user to jump in as that invitee and complete/decline the order.