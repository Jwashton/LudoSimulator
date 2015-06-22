class NewBoard
  constructor: (@game) ->
    throw "Thingy?" if @game.players.length < 2
    @main_track = (null for [0...settings.track_length])
    @starting_points = (i for i in @game.players)

class Game
  constructor: (num_players) ->
    @players = (i for i in [0...num_players])
