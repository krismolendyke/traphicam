# This core class wires up the rest of the application on-demand.
class trphcm
    constructor: ->
        $('div#road').live 'pageshow', =>
            @road = new Road(@) unless @road

        # Only load up Nearby logic when necessary.
        $('div#nearby').live 'pageshow', =>
            @nearby = new Nearby(@) unless @nearby
            @nearby.sendCurrentPosition()
