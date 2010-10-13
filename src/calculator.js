(function() {
  var CommentStateMachine, Line, SLOCCounter, _;
  _ = (require('underscore'))._;
  SLOCCounter = function(_arg) {
    this.code = _arg;
    return this;
  };
  SLOCCounter.prototype.count = function() {
    var _i, _len, _ref, line, total;
    this.commentStateMachine = new CommentStateMachine();
    total = 0;
    _ref = this.parseCodeIntoLines();
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      line = _ref[_i];
      this.commentStateMachine.step(line);
      total += this.countLine(line);
    }
    return total;
  };
  SLOCCounter.prototype.parseCodeIntoLines = function() {
    var makeLine;
    makeLine = function(text) {
      return new Line(text);
    };
    return _.map(this.code.split('\n'), makeLine);
  };
  SLOCCounter.prototype.isComment = function(line) {
    return this.commentStateMachine.inMultiLineString ? false : this.commentStateMachine.inComment || line.isComment();
  };
  SLOCCounter.prototype.countLine = function(line) {
    return this.isComment(line) ? 0 : 1;
  };
  Line = function(_arg) {
    this.text = _arg;
    return this;
  };
  Line.prototype.containsUnclosedMultiLineString = function() {
    return this.text.match("('''){1,1}") || this.text.match('\"{1,1}');
  };
  Line.prototype.isEmpty = function() {
    return this.text.length === 0;
  };
  Line.prototype.isBlockComment = function() {
    return this.text.match('^\s*###.*$');
  };
  Line.prototype.isComment = function() {
    return this.text.match('^( *)#') || this.isEmpty();
  };
  CommentStateMachine = function() {
    this.inComment = false;
    this.inMultiLineString = false;
    return this;
  };
  CommentStateMachine.prototype.step = function(line) {
    if (line.containsUnclosedMultiLineString()) {
      this.toggleInMultiLineString();
    }
    return !(this.inMultiLineString) ? (line.isBlockComment() ? this.toggleInComment() : null) : null;
  };
  CommentStateMachine.prototype.toggleInComment = function() {
    return (this.inComment = !this.inComment);
  };
  CommentStateMachine.prototype.toggleInMultiLineString = function() {
    return (this.inMultiLineString = !this.inMultiLineString);
  };
  exports.SLOCCounter = SLOCCounter;
  exports.Line = Line;
}).call(this);
