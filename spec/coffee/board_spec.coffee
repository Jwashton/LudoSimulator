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
      has_pieces = false
      for space in board.main_track
        has_pieces = true if space?
      
      expect(has_pieces).toBeFalsy()
  
  describe ".starting_points", ->
    it "has a point for each player", ->
      expect(board.starting_points.length).toBe game.players.length
    
    it "does not have any overlapping elements", ->
      unique = board.starting_points.filter (point, i, points) ->
        i == points.indexOf point
      expect(board.starting_points).toEqual unique
