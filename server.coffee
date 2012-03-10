require('zappa') ->
    @use 'static'

    @get '/': ->
        @render index: title: 'traphicam'

    @view index: ->
        li id: 'cameras', 'data-role': 'listview'

    @coffee '/client.js': ->
        positionCallback = (position) ->
            lat = position.coords.latitude
            lng = position.coords.longitude
            acc = (position.coords.accuracy * 3.281).toFixed(0)
            date = new Date(position.timestamp)
            host = 'http://localhost:1776'
            num = 4

            $.getJSON "#{host}/#{lat}/#{lng}/#{num}?callback=?", (data) ->
                $.each data, ->
                    $('#cameras').append """
<li>
    <img src='#{@.url}' />
    <h3>#{@.name}</h3>
    <p class='ui-li-aside'>#{@.miles_away}mi away</p>
</li>
"""

        $('div[data-role="page"]').live 'pageinit', (e) ->
            if not window.already and navigator.geolocation
                window.already = true
                navigator.geolocation.getCurrentPosition positionCallback

    @view layout: ->
        doctype 5
        html ->
            head ->
                title @title
                meta name: 'viewport', content: 'width=device-width, initial-scale=1'
                link rel: 'stylesheet', href: 'http://code.jquery.com/mobile/1.0.1/jquery.mobile-1.0.1.min.css'
                link rel: 'stylesheet', href: 'css/trphcm.css'
                # link rel: 'stylesheet', href: 'css/jquery.mobile-1.0.1.css'
            body ->
                div 'data-role': 'header', -> h1 @title
                div 'data-role': 'content', -> @body
                script src: 'http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js'
                script src: 'http://code.jquery.com/mobile/1.0.1/jquery.mobile-1.0.1.min.js'
                script src: 'client.js'
                # script src: 'js/jquery-1.7.1.js'
                # script src: 'js/jquery.mobile-1.0.1.js'
                # script src: 'js/client.js'
