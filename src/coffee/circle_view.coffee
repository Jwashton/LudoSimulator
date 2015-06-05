$ ->
  class window.CircleView extends BoardView
    constructor: (context, board) ->
      @track_radius = 270
      
      super(context, board)
    
    calcCircleLocation: (space, radius) ->
      center =
        x: window.innerWidth / 2
        y: window.innerHeight / 2
      
      x = center.x + radius * Math.cos(2 * Math.PI * space / 52)
      y = center.y + radius * Math.sin(2 * Math.PI * space / 52)
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
        text_loc = @calcCircleLocation(space, radius - @v_text_offset)
        @context.fillText(@board.reserves[player], text_loc.x, text_loc.y)
    
    drawHouses: ->
      space_dist = @space_height() + @space_padding_bottom
      for location, player in @board.doors
        
        for occupied, space in @board.houses[player]
          radius = @track_radius - (space + 1) * space_dist
          loc = @calcCircleLocation(location, radius)
          color = @colors.players[player]
          @drawCircle(loc.x, loc.y, @space_radius, color)
          
          color = if occupied? then @colors.players[occupied] else @colors.space
          @drawCircle(loc.x, loc.y, @token_radius(), color)
          
        radius = @track_radius - 7 * space_dist
        loc = @calcCircleLocation(location, radius)
        text_loc =
          x: loc.x + @goal_width / 2 - @h_text_offset
          y: loc.y + @goal_height / 2 - @h_text_offset
        
        if @board.goals[player] == 4
          @context.fillStyle = @colors.players[player]
          @context.fillRect(loc.x, loc.y, @goal_width, @goal_height)
        else
          @context.strokeStyle = @colors.players[player]
          @context.strokeRect(loc.x, loc.y, @goal_width, @goal_height)
        @context.fillStyle = @colors.text
        @context.fillText(@board.goals[player], text_loc.x, text_loc.y)
