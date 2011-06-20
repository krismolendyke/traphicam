# Cameras by road that they are on view.
view roads: ->
    div 'data-role': 'page', id: 'roads', ->
        div 'data-role': 'header', 'data-position': 'fixed', ->
            h1 'Cameras By Road'
        div 'data-role': 'content', ->
            ul
                id: 'road-list'
                'data-role': 'listview'
                'data-filter': true
                'data-filter-placeholder': 'Filter roads...'
                class: 'ui-listview'

            # A road list item that represents a road with cameras that can be
            # laid out directionally (N, S, E, W).
            script id: 'road-direction-item', type: 'text/x-jquery-tmpl', ->
                li class: 'road-direction-item ui-li ui-li-static ui-body-c', ->
                    h3 class: 'ui-li-heading', '${name}'
                    p class: 'ui-li-desc', -> '${cameraCount} cameras'
                    img class: 'road-sign', src: 'img/${roadId}.png', alt: '${name}'
                    div class: 'road-directions', ->
                        a class: 'road-direction', 'data-direction': '${directions[0]}', ->
                            img class: 'road-direction',
                                alt: '${directions[0]}',
                                src: """
                                {{if name.indexOf('Interstate') === 0}}
                                    img/${directions[0]}-blue.png
                                {{else}}
                                    img/${directions[0]}-white.png
                                {{/if}}
                            """
                        a class: 'road-direction', 'data-direction': '${directions[1]}', ->
                            img class: 'road-direction',
                                alt: '${directions[1]}',
                                src: """
                                {{if name.indexOf('Interstate') === 0}}
                                    img/${directions[1]}-blue.png
                                {{else}}
                                    img/${directions[1]}-white.png
                                {{/if}}
                            """

            # A road list item that does not have cameras that can be laid out
            # directionally.  This could be because there is only a single
            # camera, or because the item represents more than one road.
            script id: 'road-item', type: 'text/x-jquery-tmpl', ->
                li class: 'road-item ui-li-has-thumb ui-btn ui-btn-icon-right ui-li ui-btn-down-c ui-btn-up-c', 'data-theme': 'c', ->
                    div class: 'ui-btn-inner ui-li', ->
                        div class: 'ui-btn-text', ->
                            a class: 'ui-link-inherit', href: '#', ->
                                h3 class: 'ui-li-heading', '${name}'
                                p class: 'ui-li-desc', -> """
                                    {{if cameraCount === 1}}
                                        ${cameraCount} camera
                                    {{else}}
                                        ${cameraCount} cameras
                                    {{/if}}
                                """
                                img class: 'road-sign ui-li-thumb', src: 'img/${roadId}.png', alt: '${name}'
                                span class: 'ui-icon ui-icon-arrow-r'
