Meteor.publish 'bros', ->
  Bros.find( {} )

Meteor.publish 'menu', ->
  Menu.find( {} )
