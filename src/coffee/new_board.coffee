class NewBoard
  constructor: ->
    @main_track = (null for [0...settings.track_length])
    @starting_points = []
    @players = []
