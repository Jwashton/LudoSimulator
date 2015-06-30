class NewBoard
  constructor: (@game) ->
    @verify_game_ready()
    
    @main_track = @construct_track(settings.track_length)
    
    player_buffer = @main_track.length / @game.players.length
    
    @starting_points = []
    @staging_zones   = []
    @doors           = []
    @safe_zones      = []
    @houses          = []
    
    for player in @game.players
      starting_point = Math.round(player * player_buffer)
      distance = @confine_track_index(starting_point + settings.door_distance)
      
      @starting_points.push starting_point
      @staging_zones.push   settings.starting_tokens
      @doors.push           distance
      @safe_zones.push      @construct_track(settings.safe_zone_length)
      @houses.push          0
  
  verify_game_ready: ->
    throw new Error('Too few players!') unless @game.players.length
  
  construct_track: (length) ->
    (null for [0...length])
  
  # Takes an int and confines it to the length of the main track
  confine_track_index: (index) ->
    index % @main_track.length
  
  # Takes a player-biased position, and calculates the actual position
  get_location: (player, location) ->
    (@starting_points[player] + location) % @main_track.length
  # Takes a player-biased position, and returns the value at the actual position
  # Takes a player-biased position and a value and sets the actual position to
  #    the value

class Game
  constructor: (num_players) ->
    @players = (i for i in [0...num_players])
