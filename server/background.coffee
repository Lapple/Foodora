logOrder = ( bro ) ->
  if bro.ordered
    Bros.update( bro._id,
      $push:
        log:
          date      : bro.last
          meal      : bro.meal
          timestamp : bro.timestamp
    )

  Bros.update( bro._id,
    $unset:
      meal        : 1
      ordered     : 1
      missingFood : 1
  )

logOrders = ->
  Bros.find
    last: { $ne: getToday() }
  .forEach logOrder

Meteor.methods
  cleanUp: logOrders

###
Meteor.startup ->
  # Logging previous entries every single day
  Cron.instance.addJob 1, logOrders
###
