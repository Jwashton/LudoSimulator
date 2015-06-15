$ ->
  class window.Board
    constructor: (@players, @die, @context) ->
      @currentPlayer = 3
      @again = false
      @track = (null for i in [0..51])
      @doors = [50, 24, 11, 37]
      @starts = [0, 26, 13, 39]
      @houses = [[null, null, null, null, null]
                 [null, null, null, null, null]
                 [null, null, null, null, null]
                 [null, null, null, null, null]]
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
        if pDestination == 5
          @deliverPiece(player)
          @houses[player][pSource] = null
        else if pDestination < 5
          unless @houses[player][pDestination]?
            @houses[player][pSource] = null
            @houses[player][pDestination] = player
      else if @track[source] == player
        door = @doors[player]
        
        # If we can enter home
        if source == door or (source < door and source + steps > door)
          interiorSteps = steps - (door - source) - 1
          
          unless @houses[player][interiorSteps]?
            @track[source] = null
            @houses[player][interiorSteps] = player
        
        else
          unless @track[destination] == player
            if @track[destination]?
              @returnPiece destination
            
            @track[source] = null
            @track[destination] = player
