(function() {
  var Line, SLOCCounter, count;
  require.paths.push("../../src");
  SLOCCounter = (require('calculator')).SLOCCounter;
  count = function(code) {
    return new SLOCCounter(code).count();
  };
  describe('the count of lines of coffeescript code', function() {
    it('is 0 for an empty string', function() {
      return expect(count('')).toEqual(0);
    });
    describe('counting a single line with no context', function() {
      describe('a line of code', function() {
        return it('is 1 for a string with one line of code', function() {
          return expect(count('console.log "foo"')).toEqual(1);
        });
      });
      return describe('a comment line', function() {
        return it('is 0 for a line that starts with a comment', function() {
          expect(count('#COMMENT')).toEqual(0);
          return expect(count(' #COMMENT')).toEqual(0);
        });
      });
    });
    describe('counting a multi-line string', function() {
      return describe('with a block comment inside', function() {
        return it('still counts lines', function() {
          return expect(count('"### NOT A BLOCK COMMENT\n fooo"')).toEqual(2);
        });
      });
    });
    describe('counting a block comment', function() {
      describe('a block comment and no code', function() {
        return it('has no lines of code', function() {
          return expect(count('###BLOCK COMMENT\nThis is still a comment\n### END BLOCK')).toEqual(0);
        });
      });
      return describe('a block comment and one line of code', function() {
        return it('has one line', function() {
          return expect(count('lineOfCode()\n###BLOCK COMMENT\nstill a comment\n### END BLOCK')).toEqual(1);
        });
      });
    });
    return it('is two for a string with two lines of code', function() {
      expect(count('1+1"\n1+1')).toEqual(2);
      return expect(count('1+1"\n1+1')).toEqual(2);
    });
  });
  Line = (require('calculator')).Line;
  describe('lines', function() {
    describe('comments', function() {
      it('has no spaces in front of the #', function() {
        return expect(new Line('#COMMENT').isComment()).toBeTruthy();
      });
      return it('has spaces in front of the #', function() {
        return expect(new Line(' #COMMENT').isComment()).toBeTruthy();
      });
    });
    return describe('multi line strings', function() {
      it('not a multi line string', function() {
        return expect(new Line('#COMMENT').containsUnclosedMultiLineString()).toBeFalsy();
      });
      it('is a heredoc string', function() {
        return expect(new Line("'''# HEREDOC").containsUnclosedMultiLineString()).toBeTruthy();
      });
      return it('is a normal string', function() {
        return expect(new Line('" MULTI LINE STRING').containsUnclosedMultiLineString()).toBeTruthy();
      });
    });
  });
}).call(this);
