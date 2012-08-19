do ->
  dateFormat = 'DD.MM.YYYY'

  $el = ( id ) ->
    document.getElementById id

  setOrder = ( id, meal ) ->
    Bros.update { _id: id }, {
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

  setTyping = ( id, typing ) ->
    Bros.update { _id: id }, {
      $set: {
        typing: typing
      }
    }

  restoreAddability = ->
    removeBro Session.get 'id'
    return false

  Template.bros.bros = ->
    Bros.find( {}, { sort: { ordered: -1, name: 1 } } ).fetch()

  Template.bro.controlled = ->
    Session.get( 'id' ) is @_id

  Template.bro.events =
    'keydown input': ( e ) ->
      # Enter key
      if e.keyCode is 13
        e.target.blur()

    'focus input': ->
      setTyping @_id, true

    'blur input': ( e ) ->
      setOrder @_id, e.target.value
      setTyping @_id, false

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

  Meteor.startup ->
    # Setting current id
    id = localStorage.getItem 'ids'
    Session.set 'id', id if id

