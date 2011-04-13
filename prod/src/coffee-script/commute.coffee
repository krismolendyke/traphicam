class Cams
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
            @spinner.show()
            navigator.geolocation.getCurrentPosition @geoLocSuccess
            navigator.geolocation.watchPosition @watchSuccess
        
        $('button#reverse').click => @load()

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
            @positionList.append $('script#position-item').tmpl position

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

        # @load destination

    geoLocError: (error) -> console.log 'shit'
            
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

$ -> new Cams()
