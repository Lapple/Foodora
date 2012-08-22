$el = ( id ) ->
  document.getElementById id

do ->
  dateFormat = 'DD.MM.YYYY'

  setOrder = ( meal ) ->
    Bros.update { _id: Session.get( 'id' ) }, {
      $set: {
        ordered : meal.length > 0
        meal    : meal
        last    : getToday()
      }
    }

  removeBro = ( id ) ->
    Bros.remove id
    localStorage.removeItem 'ids'
    Session.set 'id', false

  addBro = ( name ) ->
    return if name.length is 0

    id = Bros.insert
      name    : name
      ordered : false
      typing  : false
      log     : []
      last    : getToday()

    setControlledID id

  setControlledID = ( id ) ->
    localStorage.setItem 'ids', id
    Session.set 'id', id

  setTyping = ( typing ) ->
    Bros.update { _id: Session.get( 'id' ) }, {
      $set: {
        typing: typing
      }
    }

  restoreAddability = ->
    removeBro Session.get 'id'
    return false

  Template.app.isHomePage = ->
    Session.equals 'currentPage', 'home'

  Template.app.isMenuPage = ->
    Session.equals 'currentPage', 'menu'

  Template.bros.bros = ->
    Bros.find( Session.get 'id' ).fetch().concat(
      Bros.find( { _id: { $ne: Session.get 'id' } }, { sort: { ordered: -1, name: 1 } } ).fetch()
    )

  Template.bros.user = ->
    Session.get 'id'

  Template.bro.controlled = ->
    Session.get( 'id' ) is @_id

  Template.bro.meals = ->
    Menu.find().map ( meal ) ->
      "\"#{ meal.title }\""
    .join ','

  Template.bro.events =
    'submit form': ( e ) ->
      $el( "id-#{ @_id }" ).blur()
      return false

    'focus input': ->
      setTyping true

    'blur input': ( e ) ->
      setTyping false
      # A small hack used to get the updated value of
      # the input after Bootstrap's Typeahead plugin
      # changes value on click
      Meteor.setTimeout ->
        setOrder e.target.value
      , 100

  Template.header.events =
    'click [data-action=restart]': restoreAddability

  Template.addForm.id = ->
    Session.get 'id'

  Template.addForm.events =
    'submit form': ->
      input = $el( 'new-name' )

      addBro input.value
      input.value = ''

      return false

  Template.removeModal.events =
    'click #cross': ->
      removeBro Session.get 'id'

  Template.ordersLog.humanize = ( date ) ->
    moment( date, dateFormat ).fromNow()

  Template.ordersLog.orders = ->
    id   = Session.get 'id'
    logs = []

    Bros.find( id ).forEach ( bro ) ->
      logs = bro.log?.sort ( a, b ) ->
        moment( b.date, dateFormat ).unix() - moment( a.date, dateFormat ).unix()

    return logs

  Template.ordersLog.events =
    'click tr': ->
      $el( "id-#{ Session.get 'id' }" ).value = @meal
      setOrder @meal

  # Routing
  Router = Backbone.Router.extend
    routes:
      ''     : 'home'
      'menu' : 'menu'

    home: ->
      Session.set 'currentPage', 'home'

    menu: ->
      Session.set 'currentPage', 'menu'

  app = new Router

  Meteor.startup ->
    # Setting current id
    id = localStorage.getItem 'ids'
    Session.set 'id', id if id

    Backbone.history.start( pushState: true )



