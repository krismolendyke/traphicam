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
                        p "Find cameras by the roads they're on"
                li ->
                    a href: 'nearby', ->
                        img class: 'ui-li-icon',
                            src: 'img/74-location.png',
                            alt: 'Location'
                        h1 'Cameras nearby'
                        p 'Using your current position'
                li ->
                    a href: 'about', ->
                        img class: 'ui-li-icon',
                            src: 'img/traphicam.png',
                            alt: 'About'
                        h1 'About'

