require.paths.push("../../src");
SLOCCounter = (require 'calculator').SLOCCounter

count = (code) ->
  new SLOCCounter(code).count()

describe 'the count of lines of coffeescript code', ->
  it 'is 0 for an empty string',->
    expect(count('')).toEqual 0

  describe 'counting a single line with no context',->
    describe 'a line of code', ->
      it 'is 1 for a string with one line of code',->
        expect(count('console.log "foo"')).toEqual 1

    describe 'a comment line', ->
      it 'is 0 for a line that starts with a comment',->
        expect(count('#COMMENT')).toEqual 0
        expect(count(' #COMMENT')).toEqual 0

  describe 'counting a multi-line string',->
    describe 'with a block comment inside',->
      it 'still counts lines',->
        expect(count('''"### NOT A BLOCK COMMENT\n fooo"''')).toEqual 2

  describe 'counting a block comment',->
    describe 'a block comment and no code',->
      it 'has no lines of code',->
        expect(count '''###BLOCK COMMENT
                        This is still a comment
                        ### END BLOCK''').toEqual 0

    describe 'a block comment and one line of code',->
      it 'has one line',->
        expect(count '''lineOfCode()
                        ###BLOCK COMMENT
                        still a comment
                        ### END BLOCK''').toEqual 1

  it 'is two for a string with two lines of code',->
    expect(count('1+1"\n1+1')).toEqual 2
    expect(count('1+1"\n1+1')).toEqual 2

Line = (require 'calculator').Line
describe 'lines', ->
  describe 'comments',->
    it 'has no spaces in front of the #', ->
      expect(new Line('#COMMENT').isComment()).toBeTruthy()

    it 'has spaces in front of the #', ->
      expect(new Line(' #COMMENT').isComment()).toBeTruthy()

  describe 'multi line strings',->
    it 'not a multi line string', ->
      expect(new Line('#COMMENT').containsUnclosedMultiLineString()).toBeFalsy()

    it 'is a heredoc string',->
      expect(new Line("'''# HEREDOC").containsUnclosedMultiLineString()).toBeTruthy()

    it 'is a normal string',->
      expect(new Line('" MULTI LINE STRING').containsUnclosedMultiLineString()).toBeTruthy()
