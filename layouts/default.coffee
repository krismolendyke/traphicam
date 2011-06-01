# Simple HTML5 jQueryMobile layout.
layout ->
    doctype 5
    html ->
        head ->
            meta charset: 'utf-8'
            title 'traphicam.com'
            meta
                name:'viewport'
                content: 'width=device-width, minimum-scale=1, maximum-scale=1'
            # App-wide scripts to be included on every page.
            @allScripts = [
                '/socket.io/socket.io'
                ,'http://code.jquery.com/jquery-1.6.1.min'
                ,'/js/jquery.mobile-1.0a4.1.min'
                ,'/js/jquery.tmpl.min'
                ,'/js/trphcm.min'
                ,'/js/ga'
            ]
            # Append view-specific scripts, if any are included in the view.
            @allScripts.push @scripts if @scripts?
            # Add all of the scripts to the head.
            for s in @allScripts then script src: "#{s}.js"

            # Google's JavaScript loader is goofy and doesn't work with the
            # @scripts array I've setup so it must be specified here for now.
            script src:'http://maps.google.com/maps/api/js?libraries=geometry&sensor=true'

            # Stylesheets.
            link
                rel: 'stylesheet'
                href: '/css/jquery.mobile-1.0a4.1.min.css'
            link
                rel: 'stylesheet'
                href: '/css/screen.css'
        body ->
            div 'data-role': 'page', ->
                div 'data-role': 'header', 'data-position': 'fixed', ->
                    h1 'traphicam.com'
                    a id: 'refresh', 'data-icon': 'refresh', -> 'Refresh'
                div 'data-role': 'content', -> @content
