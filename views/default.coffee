# Default view.
view ->
    h1 "#{@count} cameras available"
    p id: 'stats'
    ul
        id: 'cam-list'
        'data-role': 'listview'
        class: 'ui-listview'

    # Camera list item jQueryMobile template.
    script id: 'cam-item', type: 'text/x-jquery-tmpl', ->
        li class: 'ui-li-has-thumb ui-btn ui-btn-icon-right ui-li ui-btn-down-c ui-btn-up-c cam-li', 'data-theme': 'c', ->
            div class: 'ui-btn-inner ui-li', ->
                div class: 'ui-btn-text', ->
                    a class: 'ui-link-inherit', ->
                        img class: 'ui-li-thumb', src: '${obj.url}', alt: 'M.I.A.'
                        h3 class: 'ui-li-heading', '${obj.name}'
                        p class: 'ui-li-desc', '${dis.toFixed(2)} miles away'
