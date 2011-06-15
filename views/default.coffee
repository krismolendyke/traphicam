# Default view.
view ->
    div 'data-role': 'page', ->
        div 'data-role': 'header', 'data-position': 'fixed', ->
            h1 'traphicam'
        div 'data-role': 'content', ->
            ul 'data-role': 'listview', ->
                li class: 'ui-li-has-icon ui-btn ui-btn-icon-right ui-li ui-btn-down-c ui-btn-up-c', ->
                    div class: 'ui-btn-inner ui-li', ->
                        div class: 'ui-btn-text', ->
                            a class: 'ui-link-inherit', href: 'nearby', ->
                                img class: 'ui-li-icon ui-li-thumb',
                                    src: 'img/74-location.png'
                                    alt: 'Location'
                                h3 class: 'ui-li-heading', 'Cameras nearby'
                                p class: 'ui-li-desc', 'Using your current position'
                        span class: 'ui-icon ui-icon-arrow-r'

                li class: 'ui-li-has-icon ui-btn ui-btn-icon-right ui-li ui-btn-down-c ui-btn-up-c', ->
                    div class: 'ui-btn-inner ui-li', ->
                        div class: 'ui-btn-text', ->
                            a class: 'ui-link-inherit', href: 'roads', ->
                                img class: 'ui-li-icon',
                                    src: 'img/roads.png'
                                    alt: 'Roads'
                                h3 class: 'ui-li-heading', 'Cameras by road'
                                p class: 'ui-li-desc', 'Find cameras by the roads they are on'
                        span class: 'ui-icon ui-icon-arrow-r'

            br ->
            p "Welcome! <strong>traphicam.com</strong> will display the nearest <strong>Philadelphia regional traffic cameras</strong> to <strong>your current location</strong>, if you choose to share it. At the moment, it's probably most useful when accessed with your <strong>smart phone</strong>."
            p "Hopefully you will find it <strong>helpful during your commute</strong> or local Philly trip planning.  Many more features and improvments are coming soon including <strong>auto-refreshing</strong> and opt-in <strong>location watching</strong>. In the meantime, please excuse the rough edges of this &beta;eta software!"
