class NewBoard
  constructor: (@game) ->
    @main_track = (null for [0...settings.track_length])
    @starting_points = (i for i in @game.players)

class Game
  constructor: ->
    @players = [1, 3]
