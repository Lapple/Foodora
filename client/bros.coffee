Meteor.subscribe 'bros', ->
  Session.set 'brosLoaded', true

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
        _gaq.push ['_trackEvent', 'OrderForm', 'TypedIn']
      , 100

    'click #no-food': ->
      Meteor.setTimeout ->
        noFood = $( '#no-food' ).hasClass 'active'
        Meteor.call 'toggleEating', noFood

        if noFood
          _gaq.push ['_trackEvent', 'OrderForm', 'Cancelled']
      , 0

  Meteor.startup ->
    Meteor.call 'cleanUp'
