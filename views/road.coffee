view road: ->
    div 'data-role': 'page', id: 'road', ->
        div 'data-role': 'header', 'data-position': 'fixed', ->
            h1 "#{@roadId} #{@direction ? ''}"
            a id: 'refresh-road', 'data-icon': 'refresh', -> 'Refresh'
            a href: '/',
              'data-icon': 'home',
              'data-iconpos': 'notext',
              'data-direction': 'reverse',
              class: 'ui-btn-right jqm-home ui-btn ui-btn-icon-notext ui-btn-corner-all ui-shadow ui-btn-down-c ui-btn-up-c',
              title: 'Home',
              'data-theme': 'c', ->
                span class: 'ui-btn-inner ui-btn-corner-all', ->
                    span class: 'ui-btn-text', 'Home'
                    span class: 'ui-icon ui-icon-home ui-icon-shadow'
        div 'data-role': 'content', ->
            ul 'data-role': 'listview', class: 'cam-list', ->
                for camera in @cameras
                    li class: 'ui-li-static ui-body-c', 'data-theme': 'c', ->
                        h3 -> camera.name
                        if camera.url.indexOf('?') is 0
                            param = "&t=#{Date.now()}"
                        else
                            param = "?t=#{Date.now()}"
                        # Paragraph avoids jQM adding a -has-thumb class to the
                        # li, which is not what is desired in this view.
                        p -> img src: "#{camera.url}#{param}", alt: 'M.I.A.'
