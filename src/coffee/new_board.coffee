class NewBoard
  constructor: (@game) ->
    throw new Error('Too few players!') if @game.players.length < 2
    
    @main_track = (null for [0...settings.track_length])
    
    distance = @main_track.length / @game.players.length
    @starting_points = (Math.round(i * distance) for i in @game.players)
    
    @staging_zones = (settings.starting_tokens for i in @game.players)
    
    distance = (player_id) =>
      destination = (@starting_points[player_id] + settings.doorstep_distance)
      destination % settings.track_length
    @doorsteps = (distance(i) for i in @game.players)
    
    generate_safe_zone = -> (null for [0...settings.safe_zone_length])
    @safe_zones = (generate_safe_zone() for i in @game.players)
    
    @houses = (0 for i in @game.players)
  
  # Takes a player-biased position, and calculates the actual position
  get_location: (player, location) ->
    (@starting_points[player] + location) % @main_track.length
  # Takes a player-biased position, and returns the value at the actual position
  # Takes a player-biased position and a value and sets the actual position to
  #    the value

class Game
  constructor: (num_players) ->
    @players = (i for i in [0...num_players])
