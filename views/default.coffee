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
        li class: 'ui-li ui-li-static ui-body-c', 'data-theme': 'c', ->
            h3 class: 'ui-li-heading', '${obj.name}'
            p class: 'ui-li-desc', ->
                strong '${dis.toFixed(2)} miles away'
                ' at ${time}'
            img src: '${obj.url}', alt: 'M.I.A.'
