$ ->
  class window.Player
    constructor: (@id, @name) ->
      @rolls = 0
    
    hasStart: (board) ->
      board.reserves[@id] > 0
    
    canStart: (board, num) ->
      pieces = board.playerPieces(@id)
      num == 6 and @hasStart(board) and pieces.indexOf(0) == -1
    
    can_play: ->
      @rolls < 3
    
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
    
    get_number: (board) ->
      num = board.die.roll()
      if num == 6
        @rolls++
      else
        @rolls = 0
      num
    
    decide_move: (board, num, pieces) ->
      # If we rolled a six, and we can start a new piece
      if @canStart(board, num)
        @start(board)
      else if @hasExposed(board)
        for piece in pieces
          break if board.advanceToken(@id, piece, num, false)
      else if @hasHoused(board)
        current = board.houses[@id].indexOf(@id)
        board.advanceToken(@id, current, num, true)
    
    move: (board) ->
      num = @get_number(board)
      pieces = board.playerPieces(@id)
      
      @decide_move(board, num, pieces) if @can_play()
      
      board.goAgain() if num == 6
  
  class window.SingleMindedPlayer extends Player
    decide_move: (board, num, pieces) ->
      if @hasExposed(board)
        current = pieces[pieces.length - 1]
        board.advanceToken(@id, current, num, false)
      else if @canStart(board, num)
        @start(board)
      else if @hasHoused(board)
        current = board.houses[@id].indexOf(@id)
        board.advanceToken(@id, current, num, true)
