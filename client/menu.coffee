do ->
  addMeal = ( title ) ->
    return if title.length is 0

    Menu.insert
      title   : title
      updated : getToday()

  Template.meals.meals = ->
    Menu.find( {}, { sort: { title: 1 } } ).fetch()

  Template.addMenu.events =
    'submit #add-meal': ->
      input = $el( 'meal-name' )

      addMeal input.value
      input.value = ''

      return false