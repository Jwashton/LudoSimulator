describe "Board", ->
  it "can be constructed", ->
    board = new Board([], null, null)
    expect(board).toBeDefined()
