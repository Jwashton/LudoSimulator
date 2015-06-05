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
    
    # This should probably be in Board instead of Player
    advance: (board, source, steps, house) ->
      destination = source + steps
      
      if house
        console.log("Moving from #{source} to #{destination} in house!")
        if destination == 5
          board.deliverPiece(@id)
          board.houses[@id][source] = null
        else if destination < 5
          unless board.houses[@id][destination]?
            board.houses[@id][source] = null
            board.houses[@id][destination] = @id
      # If the piece we are trying to move is really our own
      if board.track[source] == @id
        # if we can enter home
        door = board.doors[@id]
        if source == door or (source < door and source + steps > door)
          # enter door
          interiorSteps = steps - (door - source) - 1
          
          unless board.houses[@id][interiorSteps]?
            board.track[source] = null
            board.houses[@id][interiorSteps] = @id
          
        else
          destination = (source + steps) % 52
          
          unless board.track[destination] == @id
            if board.track[destination]?
              board.returnPiece destination
            
            board.track[source] = null
            board.track[destination] = @id
      
    move: (board) ->
      num = board.die.roll()
      console.log "rolled a #{num}"
      if num == 6
        @start(board)
        board.goAgain()
      else if @hasExposed(board)
        current = board.track.indexOf(@id)
        @advance(board, current, num, false)
      else if @hasHoused(board)
        current = board.houses[@id].indexOf(@id)
        @advance(board, current, num, true)
      else
        console.log "Do Nothing"
