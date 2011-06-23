# About view.
view about: ->
    div 'data-role': 'page', ->
        div 'data-role': 'header', ->
            h1 'About traphicam'
        div 'data-role': 'content', ->
            p ->
                "Welcome! <strong>traphicam.com</strong> will display the nearest <strong>Philadelphia regional traffic cameras</strong> to <strong>your current location</strong>, if you choose to share it. At the moment, it's probably most useful when accessed with your <strong>smart phone</strong>."
            p ->
                "Hopefully you will find it <strong>helpful during your commute</strong> or local Philly trip planning.  Many more features and improvments are coming soon including <strong>auto-refreshing</strong> and opt-in <strong>location watching</strong>. In the meantime, please excuse the rough edges of this &beta;eta software!"
