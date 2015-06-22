class NewBoard
  constructor: (@game) ->
    throw new Error('Too few players!') if @game.players.length < 2
    @main_track = (null for [0...settings.track_length])
    
    distance = @main_track.length / @game.players.length
    @starting_points = (Math.round(i * distance) for i in @game.players)
    
    @staging_zones = (settings.starting_tokens for i in @game.players)

class Game
  constructor: (num_players) ->
    @players = (i for i in [0...num_players])
