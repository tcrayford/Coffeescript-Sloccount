_ = (require 'underscore')._

class SLOCCounter
  constructor: (@code) ->

  count: ->
    @commentStateMachine = new CommentStateMachine()
    total = 0
    for line in this.parseCodeIntoLines()
      @commentStateMachine.step(line)
      total += this.countLine(line)
    total

  parseCodeIntoLines: ->
    makeLine = (text) -> new Line(text)
    _.map(@code.split('\n'),makeLine)

  isCounted: (line) ->
    @commentStateMachine.countCurrentLine() && !line.isComment()

  countLine: (line) ->
    if this.isCounted(line)
      1
    else
      0

class Line
  constructor: (@text) ->

  isComment: ->
   @text.match('^( *)#') || this.isEmpty()

  isEmpty: ->
    @text.length == 0

  isBlockComment: ->
    @text.match '###.*$'

  containsUnclosedMultiLineString: ->
    @text.match("('''){1,1}") || @text.match('\"{1,1}')

class CommentStateMachine
  constructor: () ->
    @inComment = false
    @inMultiLineString = false

  step: (line) ->
    if line.containsUnclosedMultiLineString()
      this.toggleInMultiLineString()
    unless @inMultiLineString
      if line.isBlockComment()
        this.toggleInComment()

  countCurrentLine: ->
    not (@inComment unless @inMultiLineString)

  toggleInComment: ->
    @inComment = !@inComment

  toggleInMultiLineString: ->
    @inMultiLineString = !@inMultiLineString

exports.SLOCCounter = SLOCCounter
exports.Line = Line
