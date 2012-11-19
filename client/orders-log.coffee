Template.ordersLog.helpers
  humanize: ( date ) ->
    moment( date, dateFormat ).fromNow()

  orders: ->
    logs = []

    Bros.find( { owner: Meteor.userId() } ).forEach ( bro ) ->
      logs = bro.log?.sort ( a, b ) ->
        moment( b.date, dateFormat ).unix() - moment( a.date, dateFormat ).unix()

    return logs

Template.ordersLog.events
  'click tr': ->
    $el( 'my-order' ).value = @meal
    Meteor.call 'setOrder', @meal
    _gaq.push ['_trackEvent', 'OrdersLog', 'Chosen']
