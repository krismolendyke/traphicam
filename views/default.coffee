# Default view.
view ->
    div 'data-role': 'collapsible-set', ->
        div 'data-role': 'collapsible', 'data-collapsed': 'true', ->
            h3 'About'
            p "<strong>traphicam.com</strong> will display the nearest <strong>Philadelphia regional traffic cameras</strong> to <strong>your current location</strong>, if you choose to share it. At the moment, it's probably most useful when accessed with your <strong>smart phone</strong>."
            p "Hopefully you will find it <strong>helpful during your commute</strong> or local Philly trip planning.  Many more features and improvments are coming soon including <strong>auto-refreshing</strong> and opt-in <strong>location watching</strong>. In the meantime, please excuse the rough edges of this &beta;eta software!"
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
