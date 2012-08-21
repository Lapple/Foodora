Bros = new Meteor.Collection 'bros'
Menu = new Meteor.Collection 'menu'

getToday = ->
  moment().format 'DD.MM.YYYY'

logYesterdayOrder = ( bro ) ->
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

  return false

# Logging yesterday entries
Bros.find
  last:
    $ne: getToday()
.forEach logYesterdayOrder
