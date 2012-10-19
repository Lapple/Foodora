Meteor.methods
  createBro: ( name ) ->
    return if name.length is 0

    id = Bros.insert
      name        : name
      ordered     : false
      typing      : false
      missingFood : false
      log         : []
      owner       : @userId
      last        : getToday()

    return id

  bindBro: ( id ) ->
    Bros.update( id, { $set: { owner: @userId } } )

  setOrder: ( meal ) ->
    Bros.update { owner: @userId }, {
      $set: {
        ordered : meal.length > 0
        meal    : meal
        last    : getToday()
        typing  : false
      }
    }

  setTyping: ( typing ) ->
    Bros.update { owner: @userId }, {
      $set: {
        typing: typing
      }
    }

  toggleEating: ( missing ) ->
    Bros.update { owner: @userId }, {
      $set: {
        missingFood : missing
        last        : getToday()
      }
    }
