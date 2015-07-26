class window.Die
  constructor: (@numSides) ->
    @history = []
  
  roll: ->
    result = Math.floor(Math.random() * @numSides) + 1
    @history.push result
    result
  
  recentRolls: ->
    @history.slice(-20, -1)

