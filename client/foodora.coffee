Meteor.subscribe 'bros', ->
  Session.set 'brosLoaded', true

Template.header.helpers
  loaded: ->
    Session.get 'brosLoaded'

  showOrdersButton: ->
    Meteor.user() and Session.equals 'currentPage', 'home'

$el = ( id ) ->
  document.getElementById id

do ->
  formatOrder = ( order ) ->
    return order if order.length is 0
    return order.replace /^(.*),\s*$/g, '$1'

  Template.bros.helpers
    # List of bros available
    bros: ->
      sort =
        sort:
          ordered: -1
          missingFood: 1
          name: 1

      if Meteor.userId()
        Bros.find( { owner: Meteor.userId() } ).fetch().concat(
          Bros.find( { owner: { $ne: Meteor.userId() } }, sort ).fetch()
        )
      else
        Bros.find( {}, sort ).fetch()

  Template.bro.helpers
    controlled: ->
      Meteor.userId() is @owner

    meals: ->
      Menu.find().map ( meal ) ->
        "\"#{ meal.title.toLowerCase() }\""
      .join ','

    loaded: ->
      Session.get 'brosLoaded'

  Template.bro.events
    'submit form': ( e, template ) ->
      template.find( 'input' ).blur()
      return false

    'focus input': ->
      Meteor.call 'setTyping', true

    'blur input': ( e ) ->
      Meteor.call 'setTyping', false
      # A small hack used to get the updated value of
      # the input after Bootstrap's Typeahead plugin
      # changes value on click
      Meteor.setTimeout ->
        order = formatOrder e.target.value
        Meteor.call 'setOrder', order
        e.target.value = order
      , 100

    'click #no-food': ->
      Meteor.setTimeout ->
        Meteor.call 'toggleEating', $( '#no-food' ).hasClass 'active'
      , 0

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

  Meteor.startup ->
    Meteor.call 'cleanUp'
