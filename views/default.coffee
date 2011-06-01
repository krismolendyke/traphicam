# Default view.
view ->
    div 'data-role': 'collapsible-set', ->
        div 'data-role': 'collapsible', 'data-collapsed': 'true', ->
            h3 '&beta;eta Software!'
            p "<strong>traphicam.com</strong> will display the nearest <strong>Philadelphia regional traffic cameras</strong> to your current location (if you choose to share it).  Hopefully you will find it helpful- many more features and improvments are coming soon!"
        div 'data-role': 'collapsible', 'data-collapsed': 'true', ->
            h3 'Location Details'
            p id: 'stats'
    br ->
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
