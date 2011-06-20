view road: ->
    div 'data-role': 'page', id: 'road', ->
        div 'data-role': 'header', 'data-position': 'fixed', ->
            h1 "#{@road} #{@direction}"
        div 'data-role': 'content', ->
            p -> @road
            p -> @direction
