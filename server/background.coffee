logOrder = ( bro ) ->
  if bro.ordered
    Bros.update( bro._id,
      $push:
        log:
          date: bro.last
          meal: bro.meal
    )

  Bros.update( bro._id,
    $unset:
      meal: 1
      ordered: 1
  )

logOrders = ->
  Bros.find
    last: { $ne: getToday() }
  .forEach logOrder

Meteor.startup ->
  # Logging previous entries every single day
  Cron.instance.addJob 60, ->
    logOrders() if moment().hours() is 0
