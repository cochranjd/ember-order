module.exports = function(app) {
  var express = require('express');
  var apiMenuitemsRouter = express.Router();

  var records = [
            {
                id: 0,
                title: 'Sandwich',
                description: 'A delicous sandwich',
                price_in_cents: 865
            },
            {
                id: 1,
                title: 'Soup',
                description: 'A nice bowl of soup',
                price_in_cents: 865
            },
            {
                id: 2,
                title: 'Cheeseburger',
                description: 'A scrumptious cheeseburger',
                price_in_cents: 865
            },
            {
                id: 3,
                title: 'Pizza',
                description: 'A pizza pie for you',
                price_in_cents: 865
            },
            {
                id: 4,
                title: 'Chili',
                description: 'Hot, steaming chili',
                price_in_cents: 865
            },
            {
                id: 5,
                title: 'Taco',
                description: 'Enjoy a crispy taco',
                price_in_cents: 865
            },
            {
                id: 6,
                title: 'Salad',
                description: 'For the calorie concious',
                price_in_cents: 865
            },
            {
                id: 7,
                title: 'Steak',
                description: 'Steak.  Enough said',
                price_in_cents: 865
            },
            {
                id: 8,
                title: 'Chicken',
                description: 'MMMMMMMMM Chicken.',
                price_in_cents: 865
            }
        ];

  apiMenuitemsRouter.get('/', function(req, res) {
    res.send({
        menuitems: records
    });
  });

  apiMenuitemsRouter.get('/:id', function(req, res ) {
      res.send({
          menuitem: records[parseInt(req.params.id, 10)]
      });
  })
  app.use('/api/menuitems', apiMenuitemsRouter);
};
