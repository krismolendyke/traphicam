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

            # Road list item jQueryMobile template.
            script id: 'road-item', type: 'text/x-jquery-tmpl', ->
                li class: 'ui-li-has-thumb ui-btn ui-btn-icon-right ui-li ui-btn-down-c ui-btn-up-c', 'data-theme': 'c', ->
                    div class: 'ui-btn-inner ui-li', ->
                        div class: 'ui-btn-text', ->
                            a class: 'ui-link-inherit', href: '#', ->
                                img class: 'ui-li-thumb', src: 'img/${roadId}.png', alt: 'sign'
                                h3 class: 'ui-li-heading', '${name}'
                                p class: 'ui-li-desc', -> """
                                    {{if cameraCount === 1}}
                                        ${cameraCount} camera
                                    {{else}}
                                        ${cameraCount} cameras
                                    {{/if}}
                                """
                            span class: 'ui-icon ui-icon-arrow-r'
