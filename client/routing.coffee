Template.app.helpers
  isHomePage: ->
    Session.equals 'currentPage', 'home'

  isMenuPage: ->
    Session.equals 'currentPage', 'menu'

  isNotFound: ->
    Session.equals 'currentPage', '404'

  loaded: ->
    Session.get 'brosLoaded'

do ->
  Router = Backbone.Router.extend
    routes:
      ''     : 'home'
      'menu' : 'menu'
      '*404' : 'notFound'

    home: ->
      Session.set 'currentPage', 'home'

    menu: ->
      Session.set 'currentPage', 'menu'

    notFound: ->
      Session.set 'currentPage', '404'

  app = new Router

  Meteor.startup ->
    Backbone.history.start( pushState: true )

    # Hijack links
    if Backbone.history and Backbone.history._hasPushState
      # Use delegation to avoid initial DOM selection and allow all matching elements to bubble
      $( document ).on 'click', 'a', ( e ) ->
        $el      = $( @ )

        return if $el.data 'toggle'

        # Get the anchor href and protcol
        href     = $el.attr 'href'
        protocol = "#{ @protocol }//"

        # Ensure the protocol is not part of URL, meaning its relative.
        # Stop the event bubbling to ensure the link will not cause a page refresh.
        if href.slice( protocol.length ) isnt protocol
          e.preventDefault()

          # Note by using Backbone.history.navigate, router events will not be
          # triggered. If this is a problem, change this to navigate on your
          # router.
          Backbone.history.navigate href, true

