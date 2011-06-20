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

            script id: 'road-north-south-item', type: 'text/x-jquery-tmpl', ->
                li class: 'road-direction-item ui-li ui-li-static ui-body-c', ->
                    h3 class: 'ui-li-heading', '${name}'
                    p class: 'ui-li-desc', -> """
                        {{if cameraCount === 1}}
                            ${cameraCount} camera
                        {{else}}
                            ${cameraCount} cameras
                        {{/if}}
                    """
                    img class: 'road-sign', src: 'img/${roadId}.png', alt: '${name}'
                    div class: 'road-directions', ->
                        a class: 'road-direction-north', href: '#', ->
                            img class: 'road-direction',
                                alt: 'North',
                                src: """
                                {{if name.indexOf('Interstate') === 0}}
                                    img/north-blue.png
                                {{else}}
                                    img/north-white.png
                                {{/if}}
                            """
                        a class: 'road-direction-south', href: '#', ->
                            img class: 'road-direction',
                                alt: 'South',
                                src: """
                                {{if name.indexOf('Interstate') === 0}}
                                    img/south-blue.png
                                {{else}}
                                    img/south-white.png
                                {{/if}}
                            """
            script id: 'road-east-west-item', type: 'text/x-jquery-tmpl', ->
                li class: 'road-direction-item ui-li ui-li-static ui-body-c', ->
                    h3 class: 'ui-li-heading', '${name}'
                    p class: 'ui-li-desc', -> """
                        {{if cameraCount === 1}}
                            ${cameraCount} camera
                        {{else}}
                            ${cameraCount} cameras
                        {{/if}}
                    """
                    img class: 'road-sign', src: 'img/${roadId}.png', alt: '${name}'
                    div class: 'road-directions', ->
                        a class: 'road-direction-west', href: '#', ->
                            img class: 'road-direction',
                                alt: 'West',
                                src: """
                                {{if name.indexOf('Interstate') === 0}}
                                    img/west-blue.png
                                {{else}}
                                    img/west-white.png
                                {{/if}}
                            """
                        a class: 'road-direction-east', href: '#', ->
                            img class: 'road-direction',
                                alt: 'East',
                                src: """
                                {{if name.indexOf('Interstate') === 0}}
                                    img/east-blue.png
                                {{else}}
                                    img/east-white.png
                                {{/if}}
                            """
            # Road list item jQueryMobile template.
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
