# Nearby cameras view.
view nearby: ->
    div 'data-role': 'page', id: 'follow', ->
        div 'data-role': 'header', 'data-position': 'fixed', ->
            h1 'Nearby Cameras'
            a id: 'refresh', 'data-icon': 'refresh', -> 'Refresh'
        div 'data-role': 'content', ->
            div 'data-role': 'collapsible', 'data-collapsed': 'true', ->
                h3 'Location Details'
                p id: 'stats'
            br ->
            ul
                id: 'cam-list'
                'data-role': 'listview'
                'data-filter': true
                'data-filter-placeholder': 'Filter cameras...'
                class: 'ui-listview'

            # Camera list item jQueryMobile template.
            script id: 'cam-item', type: 'text/x-jquery-tmpl', ->
                li class: 'ui-li ui-li-static ui-body-c', 'data-theme': 'c', ->
                    h3 class: 'ui-li-heading', '${obj.name}'
                    p class: 'ui-li-desc', ->
                        strong '${dis.toFixed(2)} miles away'
                        ' at ${time}'
                    img src: '${obj.url}', alt: 'M.I.A.'
