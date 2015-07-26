class window.Board
  constructor: (@players, @die, @context) ->
    @main_track = (null for i in [0..51])
    @starting_points = []
    
    @currentPlayer = 3
    @again = false
    @track = @main_track
    @doors = [50, 24, 11, 37]
    @starts = [0, 26, 13, 39]
    house = -> (null for i in [0..(window.house_size - 1)])
    @houses = (house() for j in [0..(@players.length - 1)])
    @reserves = [4, 4, 4, 4]
    @goals    = [0, 0, 0, 0]
  
  checkEnd: ->
    @goals.indexOf(4)
    
  move: (view) ->
    unless @again
      @currentPlayer = (@currentPlayer + 1) % 4
    @again = false
    @players[@currentPlayer].move this
    view.draw()
  
  goAgain: ->
    @again = true
  
  returnPiece: (location) ->
    player = @track[location]
    @reserves[player]++
    @track[location] = null
  
  deliverPiece: (player) ->
    @goals[player]++
  
  # Actual to Player-Biased Position
  pbPosition: (player, location) ->
    ((location - @starts[player]) + 52) % 52
  
  # Player-Biased to Actual Position
  acPosition: (player, location) ->
    (location + @starts[player]) % 52
  
  playerPieces: (player) =>
    pieces = []
    
    for piece, space in @track
      if piece == player
        pieces.push space
    
    pieces.map((space) =>
      @pbPosition(player, space)).sort((a, b) -> a - b)
  
  advanceToken: (player, pSource, steps, inHouse) ->
    pDestination = pSource + steps
    source      = @acPosition(player, pSource)
    destination = @acPosition(player, pDestination)
    
    # The houses aren't adjusted per player, so the player source is okay
    if inHouse
      if pDestination == window.house_size
        @deliverPiece(player)
        @houses[player][pSource] = null
      else if pDestination < window.house_size
        unless @houses[player][pDestination]?
          @houses[player][pSource] = null
          @houses[player][pDestination] = player
    else if @track[source] == player
      door = @doors[player]
      
      # If we can enter home
      if source == door or (source < door and source + steps > door)
        destination = steps - (door - source) - 1
        
        if destination == window.house_size
          @deliverPiece(player)
          @track[source] = null
        else
          unless @houses[player][destination]?
            @track[source] = null
            @houses[player][destination] = player
      
      else
        unless @track[destination] == player
          if @track[destination]?
            @returnPiece destination
          
          @track[source] = null
          @track[destination] = player
        else
          return false
    else
      return false
    true
