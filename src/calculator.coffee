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

  isComment: (line) ->
    if @commentStateMachine.inMultiLineString
      false
    else
      @commentStateMachine.inComment || line.isComment()

  countLine: (line) ->
    if this.isComment(line)
      0
    else
      1

class Line
  constructor: (@text) ->

  containsUnclosedMultiLineString: ->
    @text.match("('''){1,1}") || @text.match('\"{1,1}')

  isEmpty: ->
    @text.length == 0

  isBlockComment: ->
    @text.match '^\s*###.*$'

  isComment: ->
   @text.match('^( *)#') || this.isEmpty()

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

  toggleInComment: ->
    @inComment = !@inComment

  toggleInMultiLineString: ->
    @inMultiLineString = !@inMultiLineString

exports.SLOCCounter = SLOCCounter
exports.Line = Line
