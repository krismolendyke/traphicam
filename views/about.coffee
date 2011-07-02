# About view.
view about: ->
    div 'data-role': 'page', ->
        div 'data-role': 'header', ->
            h1 'About traphicam'
        div 'data-role': 'content', ->
            div -> """
<strong>traphicam.com</strong> provides a simple interface to view the Philadelphia region's traffic cameras. The traffic cameras are installed and maintained by the <a href='http://www.dot.state.pa.us'>Pennsylvania Department of Transportation</a>.
"""
            p -> 'Try it out on your mobile phone!'
            hr ->
            h3 'Software Development'
            p -> """
The software that powers <strong>traphicam.com</strong> is developed by <a href='http://k20e.com'>Kris Molendyke</a>. It is <a href='http://www.opensource.org/licenses/mit-license.php'>open source</a> and the code is available at <a href='http://github.com/krismolendyke/traphicam'>github</a>. You can read more about the other open source technologies it uses there!
"""
            p id: 'html5-badge', ->
                a href: 'http://www.w3.org/html/logo/', ->
                    img src: 'http://www.w3.org/html/logo/badge/html5-badge-h-connectivity-css3-device-semantics.png',
                    width: '229',
                    height: '64',
                    alt: 'HTML5 Powered with Connectivity / Realtime, CSS3 / Styling, Device Access, and Semantics',
                    title: 'HTML5 Powered with Connectivity / Realtime, CSS3 / Styling, Device Access, and Semantics'
