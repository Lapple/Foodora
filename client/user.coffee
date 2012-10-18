Template.helloUser.helpers
  ownerless: ->
    Bros.find( { owner: { $exists: false } } ).fetch()

  hasBro: ->
    Bros.find( { owner: Meteor.userId() } ).count() isnt 0

  selected: ->
    Session.equals 'selected-bro', @_id

  selectedBro: ->
    Session.get 'selected-bro'

Template.helloUser.events
  'click #ownerless-list tr': ->
    if Session.equals 'selected-bro', @_id
      Session.set 'selected-bro', null
    else
      Session.set 'selected-bro', @_id

  'click #user-add': ( e, template ) ->
    id   = Session.get 'selected-bro'
    name = template.find( '#new-user-name' )?.value

    if id
      Bros.update( id, { $set: { owner: Meteor.userId() } } )

    if name
      Meteor.call 'createBro', name, ( err, id ) ->
        Meteor.flush()

    if !id and !name
      console.log 'None', id, name
      return false
