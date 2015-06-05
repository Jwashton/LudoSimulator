$ ->
  class window.BoardView
    constructor: (@context, @board) ->
      @window_padding_top = 30
      @window_padding_right = 30
      @window_padding_bottom = 30
      @window_padding_left = 30
      
      @space_radius = 10
      @space_padding_right = 5
      @space_padding_bottom = 5
      
      @goal_width = 40
      @goal_height = 30
      
      @h_text_offset = 4
      @v_text_offset = 5
      @line_height = 20
      @tab_width = 20
      
      @todolist_width = 300
      
      @colors =
        background: "#FFFFFF"
        space:      "#000000"
        text:       "#000000"
        players: ["#FF0000", "#00FF00", "#00AAFF", "#FFFF00"]
      
    space_height: ->
      @space_radius * 2
    
    token_radius: ->
      @space_radius - 2
    
    drawCircle: (x, y, radius, color) ->
      @context.fillStyle = color
      @context.beginPath()
      @context.arc(x, y, radius, 0, Math.PI * 2)
      @context.fill()
    
    clearScreen: ->
      @context.fillStyle = @colors.background
      @context.fillRect(0, 0, window.innerWidth, window.innerHeight)
    
    drawTrack: ->
      space_width = @space_height() + @space_padding_right
      
      for space in [0..51]
        x = space * space_width + @window_padding_left
        @drawCircle(x, @window_padding_top, @space_radius, @colors.space)
      
      for player, space in @board.track
        if player?
          color = @colors.players[player]
          x = space * space_width + @window_padding_left
          @drawCircle(x, @window_padding_top, @token_radius(), color)
    
    drawReserves: ->
      space_width = @space_height() + @space_padding_right
      space_y = @window_padding_top +
                @space_height() +
                @space_padding_bottom
      
      text_y = space_y + @space_radius / 2
      
      for space, player in @board.starts
        space_x = space * space_width + @window_padding_left
        @drawCircle(space_x, space_y, @space_radius, @colors.players[player])
        
        text_x = space * space_width + @window_padding_left - @h_text_offset
        @context.fillStyle = @colors.text
        @context.fillText(@board.reserves[player], text_x, text_y)
    
    drawHouses: ->
      space_width = @space_height() + @space_padding_right
      space_height = @space_height() + @space_padding_bottom
      
      for location, player in @board.doors
        location_x = location * space_width + @window_padding_left
        for occupied, space in @board.houses[player]
          space_y = space * space_height +
                    @window_padding_top +
                    @space_height() +
                    @space_padding_bottom
          
          color = @colors.players[player]
          @drawCircle(location_x, space_y, @space_radius, color)
          
          if occupied?
            color = @colors.players[occupied]
          else
            color = @colors.space
          @drawCircle(location_x, space_y, @token_radius(), color)
        
        box_x = location * space_width +
                @window_padding_left -
                @goal_width / 2
        # The 7 is 1 for the track + 5 spaces in home + 1 for you
        box_y = @window_padding_top + (@space_height() * 7)
        
        text_x = box_x + @goal_width / 2 - @h_text_offset
        text_y = box_y + @goal_height / 2 + @h_text_offset
        
        # If a player has all his pieces in the goal
        if @board.goals[player] == 4
          @context.fillStyle = @colors.players[player]
          @context.fillRect(box_x, box_y, @goal_width, @goal_height)
        else
          @context.strokeStyle = @colors.players[player]
          @context.strokeRect(box_x, box_y, @goal_width, @goal_height)
        @context.fillStyle = @colors.text
        @context.fillText(@board.goals[player], text_x, text_y)
      
    drawDie: ->
      # Draw player color dot
      currentColor = @colors.players[@board.currentPlayer]
      x = @window_padding_left
      y = window.innerHeight - @window_padding_bottom
      @drawCircle(x, y, @space_radius, currentColor)
      
      # Draw roll number
      roll = @board.die.history.splice(-1)
      @context.fillStyle = @colors.text
      x = @window_padding_left - @h_text_offset
      y = window.innerHeight - @window_padding_bottom + @v_text_offset
      @context.fillText(roll, x, y)
      
      x += @space_height() + @space_padding_right
      @context.fillText("Space to move, p to toggle play", x, y)
    
    drawTodoList: ->
      todolist = [
        "Find all current active pieces"
        "Expose Decision Points"
        "Create Strategies"
        "Highlight last move (arrows maybe?)"
      ]
      
      x = window.innerWidth - (@todolist_width + @window_padding_right)
      y = window.innerHeight -
          (@window_padding_bottom + (todolist.length + 1) * @line_height)
      @context.fillText("Todo List:", x - @tab_width, y)
      
      for item, number in todolist
        delta_row = todolist.length - number
        y = window.innerHeight -
            (@window_padding_bottom + delta_row * @line_height)
        @context.fillText(item, x, y)
      
    draw: ->
      @clearScreen()
      @context.font = "12pt serif"
      
      @drawTrack()
      @drawReserves()
      @drawHouses()
      @drawDie()
      @drawTodoList()
