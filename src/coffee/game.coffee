class Game
  constructor: (num_players) ->
    @players = (i for i in [0...num_players])
