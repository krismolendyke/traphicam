describe 'trphcm', ->
    trphcm = new window.trphcm()

    # TODO: Mock SocketIO `io` object.
    it 'is not null', -> expect(trphcm).not.toBeNull()
