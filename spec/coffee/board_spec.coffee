describe "NewBoard", ->
  board = null
  features = null
  
  game = new Game(2)
  
  it "throws an exception if given a game without any players", ->
    get_board = ( -> new NewBoard(new Game()) )
    expect(get_board).toThrow()
  
  beforeEach ->
    board = new NewBoard(game)
  
  it "can be constructed", ->
    expect(board).toBeDefined()
  
  describe ".main_track", ->
    it "is an expected length long", ->
      expect(board.main_track.length).toBe settings.track_length
    
    it "starts with all spaces empty", ->
      for space in board.main_track
        expect(space).toBeNull()
     
  describe ".player_features", ->
    beforeEach ->
      features = board.player_features
    
    it "has a collection of features for each player", ->
      expect(features.length).toBe game.players.length
    
    describe ".starting_point", ->
      it "has all of it's points acceptably equidistant", ->
        starting_points = features.map (player_feature) ->
          player_feature.starting_point
        
        expect(validate_equidistant(
          starting_points
          board.main_track.length)).toBeTruthy()
  
    describe ".staging_zone", ->
      it "has an appropriate number of tokens for each player in each zone", ->
        staging_zones = features.map (player_feature) ->
          player_feature.staging_zone
        
        for tokens in staging_zones
          expect(tokens).toBe settings.starting_tokens
  
    describe ".door", ->
      it "does not have any overlapping doors", ->
        doors = features.map (player_feature) ->
          player_feature.door
        expect(unique_elements(doors).length).toBe doors.length
    
      it "does not give any doors beyond the track length", ->
        doors = features.map (player_feature) ->
          player_feature.door
        expect(Math.max(doors...)).toBeLessThan settings.track_length
    
    describe ".safe_zone", ->
      it "has an expected number of spaces in each safe zone", ->
        safe_zones = features.map (player_feature) ->
          player_feature.safe_zone
        expect(safe_zones[0].length).toBe settings.safe_zone_length
      
      it "starts with all spaces empty", ->
        safe_zones = features.map (player_feature) ->
          player_feature.safe_zone
        for space in safe_zones[0]
          expect(space).toBeNull()
  
  describe "#get_location", ->
    it "defines zero as on the starting_point for the first player", ->
      expect(board.get_location(0, 0)).toBe features[0].starting_point
    
    it "defines zero as on the starting_point for all players", ->
      expect(board.get_location(1, 0)).toBe features[1].starting_point
    
    it "defines one as the point after the starting_point", ->
      expect(board.get_location(1, 1)).toBe(features[1].starting_point + 1)
    
    it "wraps around the board, not going beyond the track_length", ->
      expect(board.get_location(1, settings.door_distance - 2)).
        toBeLessThan settings.track_length
