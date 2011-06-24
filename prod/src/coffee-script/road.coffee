class Road
    constructor: (@trphcm) ->
        $('a#refresh-road')
            .removeClass('ui-disabled')
            .live('tap', @refresh)

    refresh: ->
        # Since camera images aren't refreshed any faster than 5 seconds, for
        # now we'll disable the refresh button for that amount of time after
        # it has been tapped.
        $(@).addClass 'ui-disabled'
        setTimeout (-> $('a#refresh-road').removeClass 'ui-disabled'), 5000

        now = Date.now()
        $('div#road').find('ul.cam-list').find('img').each ->
            src = $(@).attr 'src'
            src = "#{src.slice(0, src.indexOf('t='))}t=#{now}"
            $(@).attr 'src', src
