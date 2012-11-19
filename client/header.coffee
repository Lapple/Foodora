Template.header.events
  'click #orders-toggle': ->
    _gaq.push ['_trackEvent', 'OrdersLog', 'Opened']

Template.header.helpers
  loaded: ->
    Session.get 'brosLoaded'

  showOrdersButton: ->
    Meteor.user() and Session.equals 'currentPage', 'home'
