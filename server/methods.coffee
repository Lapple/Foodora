Meteor.methods
  createBro: ( name ) ->
    return if name.length is 0

    id = Bros.insert
      name        : name
      ordered     : false
      typing      : false
      missingFood : false
      log         : []
      owner       : Meteor.userId()
      last        : getToday()

    return id

  setOrder: ( meal ) ->
    Bros.update { owner: Meteor.userId() }, {
      $set: {
        ordered : meal.length > 0
        meal    : meal
        last    : getToday()
        typing  : false
      }
    }

  setTyping: ( typing ) ->
    Bros.update { owner: Meteor.userId() }, {
      $set: {
        typing: typing
      }
    }

  toggleEating: ( missing ) ->
    Bros.update { owner: Meteor.userId() }, {
      $set: {
        missingFood : missing
        last        : getToday()
      }
    }
