Bros = new Meteor.Collection 'bros'
Menu = new Meteor.Collection 'menu'

dateFormat = 'DD.MM.YYYY'

getToday = ->
  moment().format dateFormat

