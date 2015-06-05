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
      @goals.indexOf(4) != -1
      
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
