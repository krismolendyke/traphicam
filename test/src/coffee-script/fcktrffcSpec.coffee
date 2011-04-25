describe 'fcktrffc', ->
    fcktrffc = new window.fcktrffc()

    it 'is not fucking null', ->
        expect(fcktrffc).not.toBeNull()
    
    it 'has the expected PennDOT camera base URL', ->
        expected = 'http://164.156.16.43/public/Districts/District6/WebCams'
        expect(fcktrffc.penndotBaseUrl).toEqual expected
        