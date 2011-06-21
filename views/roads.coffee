# Cameras by road that they are on view.
view roads: ->
    div 'data-role': 'page', id: 'roads', ->
        div 'data-role': 'header', 'data-position': 'fixed', ->
            h1 'Cameras By Road'
        div 'data-role': 'content', ->
            ul id: 'road-list', class: 'ui-listview', 'data-role': 'listview', 'data-filter': true, 'data-filter-placeholder': 'Filter roads...', ->
                for road in JSON.parse @roads
                    if road.directions.length is 0 or road.cameraCount is 1
                        # A road list item that does not have cameras that can
                        # be laid out directionally.  This could be because
                        # there is only a single camera, or because the item
                        # represents more than one road.
                        li class: 'road-item ui-li-has-thumb ui-btn ui-btn-icon-right ui-li ui-btn-down-c ui-btn-up-c', 'data-theme': 'c', ->
                            div class: 'ui-btn-inner ui-li', ->
                                div class: 'ui-btn-text', ->
                                    a class: 'ui-link-inherit',
                                      href: "/roads/#{road.roadId}", ->
                                        h3 class: 'ui-li-heading', -> road.name
                                        p class: 'ui-li-desc', ->
                                            if road.cameraCount is 1
                                                '1 camera'
                                            else "#{road.cameraCount} cameras"
                                        img class: 'road-sign ui-li-thumb',
                                            src: "img/#{road.roadId}.png",
                                            alt: "#{road.name}"
                                        span class: 'ui-icon ui-icon-arrow-r'

                    else if road.directions.length is 2
                        # A road list item that represents a road with cameras
                        # that can be laid out directionally (N, S, E, W).
                        li class: 'road-direction-item ui-li ui-li-static ui-body-c', ->
                            h3 class: 'ui-li-heading', -> road.name
                            p class: 'ui-li-desc', ->
                                "#{road.cameraCount} cameras"
                            img class: 'road-sign',
                                src: "img/#{road.roadId}.png",
                                alt: "#{road.name}"
                            div class: 'road-directions', ->
                                if road.name.indexOf 'Interstate' is 0
                                    color = 'blue'
                                else color = 'white'
                                for direction in road.directions
                                    a class: 'road-direction',
                                      href: "/roads/#{road.roadId}/#{direction}", ->
                                        img class: 'road-direction',
                                            alt: "#{direction}",
                                            src: "img/#{direction}-#{color}.png"
