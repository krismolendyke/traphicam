# Nearby cameras view.
view nearby: ->
    div 'data-role': 'page', id: 'follow', ->
        div 'data-role': 'header', 'data-position': 'fixed', ->
            h1 'Cameras Nearby'
            a id: 'refresh', 'data-icon': 'refresh', -> 'Refresh'
        div 'data-role': 'content', ->
            div 'data-role': 'collapsible', 'data-collapsed': 'true', ->
                h3 'Location Details'
                p id: 'stats'
            br ->
            ul id: 'cam-list', 'data-role': 'listview', 'data-filter': true, 'data-filter-placeholder': 'Filter cameras...', class: 'cam-list ui-listview'

            # Camera list item jQueryMobile template.
            script id: 'cam-item', type: 'text/x-jquery-tmpl', ->
                li class: 'ui-li ui-li-static ui-body-c', 'data-theme': 'c', ->
                    h3 class: 'ui-li-heading', '${obj.name}'
                    p class: 'ui-li-desc', ->
                        strong '${dis.toFixed(2)} miles away'
                        ' at ${time}'
                    # Paragraph avoids jQM adding a -has-thumb class to the
                    # li, which is not what is desired in this view.
                    p -> img src: '${obj.url}', alt: 'M.I.A.'
