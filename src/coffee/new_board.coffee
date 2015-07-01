class NewBoard
  constructor: (@game) ->
    @verify_game_ready()
    
    @main_track = @construct_track(settings.track_length)
    
    player_buffer = @main_track.length / @game.players.length
    
    @player_features = []
    
    for player in @game.players
      starting_point = Math.round(player * player_buffer)
      distance = @confine_to_track(starting_point + settings.door_distance)
      
      @player_features.push
        starting_point: starting_point
        staging_zone:   settings.starting_tokens
        door:           distance
        safe_zone:      @construct_track(settings.safe_zone_length)
        house:          0
  
  verify_game_ready: ->
    throw new Error('Too few players!') unless @game.players.length
  
  construct_track: (length) ->
    (null for [0...length])
  
  # Takes an int and confines it to the length of the main track
  confine_to_track: (index) ->
    index % @main_track.length
  
  # Takes a player-biased position, and calculates the actual position
  get_location: (player, location) ->
    index: @confine_to_track(@player_features[player].starting_point + location)
  # Takes a player-biased position, and returns the value at the actual position
  # Takes a player-biased position and a value and sets the actual position to
  #    the value

class Game
  constructor: (num_players) ->
    @players = (i for i in [0...num_players])
