describe "NewBoard", ->
  board = null
  
  game = new Game(2)
  
  it "throws an exception if given a game with fewer than 2 players", ->
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
  
  describe ".starting_points", ->
    it "has a point for each player", ->
      expect(board.starting_points.length).toBe game.players.length
    
    it "has all of it's points acceptably equidistant", ->
      expect(validate_equidistant(
        board.starting_points,
        board.main_track.length)).toBeTruthy()
  
  describe ".staging_zones", ->
    it "has a zone for each player", ->
      expect(board.staging_zones.length).toBe game.players.length
    
    it "has an appropriate number of tokens for each player in each zone", ->
      for tokens in board.staging_zones
        expect(tokens).toBe settings.starting_tokens
  
  describe ".safe_zones", ->
    it "has a zone for each player", ->
      expect(board.safe_zones.length).toBe game.players.length
    
    it "has an expected number of spaces in each safe zone", ->
      expect(board.safe_zones[0].length).toBe settings.safe_zone_length
    
    it "starts with all spaces empty", ->
      for space in board.safe_zones[0]
        expect(space).toBeNull()
  
  describe ".houses", ->
    it "has a home for each player", ->
      expect(board.houses.length).toBe game.players.length
  
  describe "#get_location", ->
    it "defines zero as on the starting_point for the first player", ->
      expect(board.get_location(0, 0)).toBe board.starting_points[0]
    
    it "defines zero as on the starting_point for all players", ->
      expect(board.get_location(1, 0)).toBe board.starting_points[1]
    
    it "defines one as the point after the starting_point", ->
      expect(board.get_location(1, 1)).toBe(board.starting_points[1] + 1)
    
    it "wraps around the board, not going beyond the track_length", ->
      expect(board.get_location(1, 30)).toBeLessThan settings.track_length
