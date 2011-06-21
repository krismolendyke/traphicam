# Simple HTML5 jQueryMobile layout.
layout ->
    doctype 5
    html ->
        head ->
            meta charset: 'utf-8'
            title 'traphicam'
            meta
                name: 'viewport'
                content: 'width=device-width, minimum-scale=1, maximum-scale=1'
            # App-wide scripts to be included on every page.
            @allScripts = [
                '/socket.io/socket.io'
                ,'http://code.jquery.com/jquery-1.6.1.min'
                ,'/js/jquery.mobile-1.0b2pre.min'
                ,'/js/jquery.tmpl.min'
                ,'/js/trphcm.min'
                ,'/js/ga'
            ]
            # Append view-specific scripts, if any are included in the view.
            @allScripts.push @scripts if @scripts?
            console.log @allScripts
            # Add all of the scripts to the head.
            for s in @allScripts
                # Google maps API uses its own format, i.e.:
                # http://maps.google.com/maps/api/js?libraries=geometry&sensor=true
                if s.indexOf('maps.google.com') is 0
                    script src: "#{s}"
                else
                    script src: "#{s}.js"

            # Stylesheets.
            link
                rel: 'stylesheet'
                href: '/css/jquery.mobile-1.0b2pre.min.css'
            link
                rel: 'stylesheet'
                href: '/css/screen.css'
        body -> @content
