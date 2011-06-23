# Default view.
view ->
    div 'data-role': 'page', ->
        div 'data-role': 'header', 'data-position': 'fixed', ->
            h1 'traphicam'
        div 'data-role': 'content', ->
            ul 'data-role': 'listview', ->
                li ->
                    a href: 'roads', ->
                        img class: 'ui-li-icon',
                            src: 'img/roads.png',
                            alt: 'Roads'
                        h1 'Cameras by road'
                        p 'Find cameras by the roads they are on'
                li ->
                    a href: 'nearby', ->
                        img class: 'ui-li-icon',
                            src: 'img/74-location.png',
                            alt: 'Location'
                        h1 'Cameras nearby'
                        p 'Using your current position'
            br ->
            p ->
                "Welcome! <strong>traphicam.com</strong> will display the nearest <strong>Philadelphia regional traffic cameras</strong> to <strong>your current location</strong>, if you choose to share it. At the moment, it's probably most useful when accessed with your <strong>smart phone</strong>."
            p ->
                "Hopefully you will find it <strong>helpful during your commute</strong> or local Philly trip planning.  Many more features and improvments are coming soon including <strong>auto-refreshing</strong> and opt-in <strong>location watching</strong>. In the meantime, please excuse the rough edges of this &beta;eta software!"
