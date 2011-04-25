@.fcktrfc.cams = class Cams
    baseUrl: 'http://164.156.16.43/public/Districts/District6/WebCams'
    toWork: [
        51, 50, 49, 48, 46, 45, 44, 71, 72, 73, 93, 94, 95, 96, 97, 98, 99,
        100, 101, 174, 175, 176, 133, 134, 135, 136, 137, 138, 139, 140, 141,
        142
    ]
    
    constructor: ->
        @home = new google.maps.LatLng 40.012638, -75.198691
        @work = new google.maps.LatLng 40.03734, -75.49763
        @spinner = $('img#spinner')
        @camList = $('ul#cam-list')
        @positionList = $('ul#position-list')

        if navigator.geolocation
            navigator.geolocation.getCurrentPosition @geoLocSuccess
            # navigator.geolocation.watchPosition @watchSuccess
                
        $('ul#cam-list').delegate 'li.cam-li', 'click', (event) ->
            headingText = $(event.currentTarget)
                .find('.ui-li-heading')
                .text()
        
            cam = $(event.currentTarget)
                .find('img.cam')
                .clone()
                .removeClass() 

            if $.mobile.media 'screen and (min-width: 350px)'
                cam.attr 'width', 340

            $('div#cam-detail')
                .find('#cam-detail-heading')
                    .text(headingText)
                .end()
                .find('div[data-role="content"]')
                    .empty()
                    .append(cam)
            
    watchSuccess: (position) =>
        positionLatLng = new google.maps.LatLng position.coords.latitude
                                              , position.coords.longitude

        if @lastPositionLatLng?
            difference = 
                google.maps.geometry.spherical.computeDistanceBetween positionLatLng
                                                                    , @lastPositionLatLng
                                                                    
        unless positionLatLng.equals(@lastPositionLatLng) or 
               position.coords.accuracy > difference
            position.coords.date = new Date().toLocaleTimeString()
            position.coords.difference = difference or 0
            @lastPositionLatLng = positionLatLng
            @positionList
                .append($('script#position-item').tmpl(position)).listview('refresh')

    geoLocSuccess: (position) =>
        @spinner.hide()
        current = new google.maps.LatLng position.coords.latitude
                                       , position.coords.longitude
        fromHome = 
            google.maps.geometry.spherical.computeDistanceBetween current
                                                                , @home
        fromWork = 
            google.maps.geometry.spherical.computeDistanceBetween current
                                                                , @work
        
        destination = if fromHome < fromWork then 'work' else 'home'
        
        $('div#distances')
            .html """
<strong>#{fromHome.toFixed 0}</strong>m from home, 
<strong>#{fromWork.toFixed 0}</strong>m from work.
"""
        $('span#destination').text "to #{destination}"

        @loadThumbs destination
        # @load destination

    geoLocError: (error) -> console.log 'shit'

    loadThumbs: (destination = 'work') ->
        camNumbers = @toWork.slice 0
        camNumbers.reverse() if destination is 'work'
        @camList.empty()
        date = new Date() # Let's not create a million date objects in-loop
            
        for number in camNumbers
            do (number) =>
                data = {
                    number: number
                    url: @getCamUrl number
                    date: date
                }
                camItem = $('script#cam-item').tmpl data
                @camList.append(camItem).listview('refresh')
        
        @spinner.hide()
            
    load: (destination = 'work') ->
        camNumbers = @toWork.slice 0
        camNumbers.reverse() if destination is 'work'
        @camList.empty()
            
        for number in camNumbers
            do (number) =>
                @camList.append(
                    $('<li>')
                        .addClass("ui-li ui-li-static ui-body-c")
                        .append(
                            $('<img>')
                                .attr('width', 290)
                                .attr('src', @getCamUrl number)
                            )
                    )

    getCamUrl: (number) -> 
        if number < 10 then number = "00#{number}"
        else if number < 100 then number = "0#{number}"
        
        "#{@baseUrl}/D6Cam#{number}.jpg"
