Template.broInfo.helpers
  bro: ->
    Bros.findOne Session.get 'broId'

  ordersCount: ->
    Bros.findOne( Session.get 'broId' )?.log?.length
