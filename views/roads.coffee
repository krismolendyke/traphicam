# Cameras by road that they are on view.
view roads: ->
    div 'data-role': 'page', id: 'roads', ->
        div 'data-role': 'header', 'data-position': 'fixed', ->
            h1 'Cameras By Road'
        div 'data-role': 'content', ->
            ul id: 'road-list', 'data-role': 'listview', 'data-filter': true, 'data-filter-placeholder': 'Filter roads...', ->
                for road in JSON.parse @roads
                    if road.directions.length is 0 or road.cameraCount is 1
                        # A road list item that does not have cameras that can
                        # be laid out directionally.  This could be because
                        # there is only a single camera, or because the item
                        # represents more than one road.
                        li -> a href: "/roads/#{road.roadId}", -> road.name

                    else if road.directions.length is 2
                        # A road list item that represents a road with cameras
                        # that can be laid out directionally (N, S, E, W).
                        li ->
                            for direction in road.directions
                                a 'data-theme': 'c',
                                  'data-icon': "trphcm-#{direction}",
                                  href: "/roads/#{road.roadId}/#{direction}",
                                  ->
                                    h1 "#{road.name} #{direction}"
                                    p "#{road.cameraCount} Cameras"
