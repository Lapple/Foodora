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

addBro = ( name ) ->
  return if name.length is 0

  id = Bros.insert
    name    : name
    ordered : false
    typing  : false
    last    : getToday()

  setControlledID id

getControlledID = ->
  localStorage.getItem 'ids'

setControlledID = ( id ) ->
  localStorage.setItem 'ids', id

setTyping = ( id, typing ) ->
  Bros.update { _id: id }, {
    $set: {
      typing: typing
    }
  }

restoreAddability = ->
  removeBro getControlledID()
  localStorage.removeItem 'ids'
  Meteor.flush()

  return false

getToday = ->
  moment().format 'DD.MM.YYYY'

Template.bros.bros = ->
  Bros.find( {}, { sort: { ordered: -1, name: 1 } } ).fetch()

Template.bro.controlled = ->
  getControlledID() is @_id

Template.addForm.addable = ->
  !getControlledID()

Template.bro.events =
  'keydown input': ( e ) ->
    # Enter key
    if e.keyCode is 13
      element = $el( "id-#{ @_id }" )
      element.blur()
  'focus input': ->
    setTyping @_id, true
  'blur input': ->
    element = $el( "id-#{ @_id }" )
    setOrder @_id, element.value
    setTyping @_id, false
  'click .cross': ->
    removeBro @_id

Template.header.events =
  'click [data-action=restart]': restoreAddability

Template.addForm.events =
  'submit form': ->
    input = $el( 'new-name' )
    addBro input.value
    input.value = ''

    return false

Meteor.startup ->
  unless Bros.find( { last: getToday() } ).count()
    Bros.update( last: { $ne: getToday() }, { $unset: { meal: 1, ordered: 1 } }, { multi: true } )
