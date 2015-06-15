$ ->
  class window.Player
    constructor: (@id, @name) ->
    
    hasStart: (board) ->
      board.reserves[@id] > 0
    
    canStart: (board, num) ->
      pieces = board.playerPieces(@id)
      num == 6 and @hasStart(board) and pieces.indexOf(0) == -1
    
    hasExposed: (board) ->
      board.track.indexOf(@id) != -1
    
    hasHoused: (board) ->
      board.houses[@id].indexOf(@id) != -1
    
    start: (board) ->
      if @hasStart(board)
        board.reserves[@id] -= 1
        if board.track[board.starts[@id]]?
          board.returnPiece board.starts[@id]
        board.track[board.starts[@id]] = @id
    
    move: (board) ->
      num = board.die.roll()
      
      pieces = board.playerPieces(@id)
      
      # If we rolled a six, and we can start a new piece
      if @canStart(board, num)
        @start(board)
        board.goAgain()
      else if @hasExposed(board)
        current = pieces[0]
        board.advanceToken(@id, current, num, false)
        board.goAgain() if num == 6
      else if @hasHoused(board)
        current = board.houses[@id].indexOf(@id)
        board.advanceToken(@id, current, num, true)
