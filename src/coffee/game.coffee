class Game
  constructor: (num_players, @die) ->
    @current_player = 0
    @players = (i for i in [0...num_players])
