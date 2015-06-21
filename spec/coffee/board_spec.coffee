describe "NewBoard", ->
  board = null
  
  beforeEach ->
    board = new NewBoard()
  
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
      expect(board.starting_points.length).toBe board.players.length
