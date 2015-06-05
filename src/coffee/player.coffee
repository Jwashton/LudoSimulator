$ ->
  class window.Player
    constructor: (@id, @name) ->
    
    hasStart: (board) ->
      board.reserves[@id] > 0
    
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
      
      if num == 6
        @start(board)
        board.goAgain()
      else if @hasExposed(board)
        current = pieces[0]
        board.advanceToken(@id, current, num, false)
      else if @hasHoused(board)
        current = board.houses[@id].indexOf(@id)
        board.advanceToken(@id, current, num, true)
      else
        console.log "Do Nothing"
