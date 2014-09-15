module.exports = function(app) {
  var express = require('express');
  var ordersRouter = express.Router();
  ordersRouter.get('/:token', function(req, res) {
    res.send(
    {
      "order": {
        "id": 1,
        "token": req.params.token,
        "email": "josh.cochran@gmail.com",
        "status": "SELECTED",
        "total_price_in_cents": 2595,
        "menuitems": [
        1,
        2,
        4
        ]
      }
    });
  });
  app.use('/api/orders', ordersRouter);
};