class window.CircleView extends BoardView
  constructor: (context, board) ->
    @track_radius = 270
    
    super(context, board)
  
  calcCircleLocation: (space, radius) ->
    center =
      x: window.innerWidth / 2
      y: window.innerHeight / 2
    
    x = center.x + radius * Math.cos(2 * Math.PI * (space + 2) / 52)
    y = center.y + radius * Math.sin(2 * Math.PI * (space + 2) / 52)
    {x: x, y: y}
    
  drawTrack: ->
    for player, space in @board.track
      loc = @calcCircleLocation(space, @track_radius)
      
      @drawCircle(loc.x, loc.y, @space_radius, @colors.space)
      
      if player?
        color = @colors.players[player]
        @drawCircle(loc.x, loc.y, @token_radius(), color)
  
  drawReserves: ->
    for space, player in @board.starts
      radius = @track_radius + @space_height() + @space_padding_bottom
      loc = @calcCircleLocation(space, radius)
      
      @drawCircle(loc.x, loc.y, @space_radius, @colors.players[player])
      
      @context.fillStyle = @colors.text
      text_loc =
        x: loc.x - @space_radius / 2 + 1
        y: loc.y + @space_radius / 2
      @context.fillText(@board.reserves[player], text_loc.x, text_loc.y)
  
  drawHouses: ->
    space_dist = @space_height() + @space_padding_bottom
    for location, player in @board.doors
      
      for occupied, space in @board.houses[player]
        radius = @track_radius - (space + 1) * space_dist
        loc = @calcCircleLocation(location, radius)
        color = @colors.players[player]
        @drawCircle(loc.x, loc.y, @space_radius, color)
        
        unless occupied?
          @drawCircle(loc.x, loc.y, @token_radius(), @colors.space)
        
      radius = @track_radius -
               (@board.houses[player].length + 1.5) * space_dist
      loc = @calcCircleLocation(location, radius)
      box_loc =
        x: loc.x - (@goal_width / 2)
        y: loc.y - (@goal_height / 2)
      text_loc =
        x: box_loc.x + @goal_width / 2 - @h_text_offset
        y: box_loc.y + @goal_height / 2 + @v_text_offset
      
      style = if @board.goals[player] == 4 then 'fill' else 'stroke'
      
      # Create the boxes
      @context[style + 'Style'] = @colors.players[player]
      @context[style + 'Rect'](box_loc.x,
                               box_loc.y,
                               @goal_width,
                               @goal_height)
      
      @context.fillStyle = @colors.text
      @context.fillText(@board.goals[player], text_loc.x, text_loc.y)
