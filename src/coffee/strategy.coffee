class window.Strategy
  constructor: (@board, @player) ->
  
  # Does the player have at least one token in his reserves?
  has_start: (player) ->
    @board.reserves[player.id] > 0
  
  # Is the player currently allowed to start?
  can_start: (player, num) ->
    pieces = @board.playerPieces(player.id)
    num == window.starting_number and @has_start() and pieces.indexOf(0) == -1
  
  call: (num) ->
    if @player.can_start(@board, num)
      @player.start(@board)
