# Cameras by road that they are on view.
view roads: ->
    div 'data-role': 'page', id: 'roads', ->
        div 'data-role': 'header', 'data-position': 'fixed', ->
            h1 'Cameras By Road'
        div 'data-role': 'content', ->
            ul class: 'road-list', 'data-role': 'listview', ->
                for road in JSON.parse @roads
                    if road.directions.length is 2 and road.cameraCount > 1
                        dir0 = road.directions[0]
                        label0 = "#{dir0[0].toUpperCase()}#{dir0.slice(1)}"
                        dir1 = road.directions[1]
                        label1 = "#{dir1[0].toUpperCase()}#{dir1.slice(1)}"
                        li ->
                            div class: "road-sign road-sign-#{road.roadId}"
                            div class: 'road-directions', ->
                                div 'data-role': 'controlgroup', 'data-type': 'horizontal', ->
                                    a 'data-role': 'button',
                                      'data-icon': "trphcm-#{dir0}",
                                      'data-iconpos': 'left',
                                      class: 'direction'
                                      href: "/roads/#{road.roadId}/#{dir0}", ->
                                        "#{label0}"
                                    a 'data-role': 'button',
                                      'data-icon': "trphcm-#{dir1}",
                                      'data-iconpos': 'right',
                                      class: 'direction'
                                      href: "/roads/#{road.roadId}/#{dir1}", ->
                                        "#{label1}"
                                p -> "#{road.cameraCount} cameras"
                    else
                        li ->
                            div class: "road-sign road-sign-#{road.roadId}"
                            div class: 'road-directions', ->
                                a 'data-role': 'button',
                                  class: 'no-direction',
                                  href: "/roads/#{road.roadId}", ->
                                    "#{road.name}"
                                if road.cameraCount is 1
                                    p -> "1 camera"
                                else
                                    p -> "#{road.cameraCount} cameras"
