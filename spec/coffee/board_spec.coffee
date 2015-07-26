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
      expect(board.get_location(0, 0).index).toBe features[0].starting_point
    
    it "defines zero as on the starting_point for all players", ->
      expect(board.get_location(1, 0).index).toBe features[1].starting_point
    
    it "defines one as the point after the starting_point", ->
      subject = board.get_location(1, 1).index
      goal    = features[1].starting_point + 1
      
      expect(subject).toBe(goal)
    
    it "wraps around the board, not going beyond the track_length", ->
      expect(board.get_location(1, settings.door_distance - 2).index).
        toBeLessThan settings.track_length
  
  describe "#view", ->
    it "returns the value at a player-biased location", ->
      expect(board.view(0, 0)).toBe null
  
  describe "#stage_piece", ->
    it "moves a piece out of a player's staging zone", ->
      initial_pieces = board.player_features[0].staging_zone
      board.stage_piece(0)
      final_pieces = board.player_features[0].staging_zone
      expect(final_pieces).toBe(initial_pieces - 1)
    
    it "moves a piece into the board", ->
      board.stage_piece(0)
      expect(board.view(0, 0)).toBe 0
  
  describe "#moves", ->
    it "lists staging a piece as a move", ->
      expect(board.moves(0, 1).length).toBe 1
    
    it "does not list a staging move as available for non-staging roll", ->
      expect(board.moves(0, 1)[0].available).toBe false
    
    it "does list a staging move as availabe for a staging roll", ->
      expect(board.moves(0, 6)[0].available).toBe true
    
    it "does not list a staging move as available if the space is blocked", ->
      board.stage_piece(0)
      expect(board.moves(0, 6)[0].available).toBe false
    
    it "does not list a staging move at all if the staging_zone is empty", ->
      board.player_features[0].staging_zone = 0
      expect(board.moves(0, 6).length).toBe 0
    
    it "allows you to stage a piece, if move is available", ->
      board.moves(0, 6)[0].move()
      expect(board.view(0, 0)).toBe 0
    
    it "does not allow you to stage a piece, if move is not available", ->
      board.stage_piece(0)
      expect(board.moves(0, 6)[0].move()).toBe false
    
    it "lists a move for each piece on the board", ->
      board.set(0, 2)
      board.set(0, 4)
      expect(board.moves(0, 2).length).toBe 3
    
    it "does not list a move as available if it is blocked", ->
      board.set(0, 2)
      board.set(0, 4)
      expect(board.moves(0, 2)[1].available).toBe false
    
    it "allows you to make a move, if available", ->
      board.set(0, 2)
      board.moves(0, 2)[1].move()
      expect(board.view(0, 4)).toBe 0
    
    it "does not allow you to make a move, if it is not available", ->
      board.set(0, 2)
      board.set(0, 4)
      expect(board.moves(0, 2)[1].move()).toBe(false)
