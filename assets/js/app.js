window.autorestart=!1,window.autoplay=null,window.win_history=[0,0,0,0],window.house_size=5,$(function(){return window.Die=function(){function t(t){this.numSides=t,this.history=[]}return t.prototype.roll=function(){var t;return t=Math.floor(Math.random()*this.numSides)+1,this.history.push(t),t},t.prototype.recentRolls=function(){return this.history.slice(-20,-1)},t}()});var bind=function(t,i){return function(){return t.apply(i,arguments)}};$(function(){return window.Board=function(){function t(t,i,s){var e,o,r;this.players=t,this.die=i,this.context=s,this.playerPieces=bind(this.playerPieces,this),this.currentPlayer=3,this.again=!1,this.track=function(){var t,i;for(i=[],o=t=0;51>=t;o=++t)i.push(null);return i}(),this.doors=[50,24,11,37],this.starts=[0,26,13,39],e=function(){var t,i,s;for(s=[],o=t=0,i=window.house_size-1;i>=0?i>=t:t>=i;o=i>=0?++t:--t)s.push(null);return s},this.houses=function(){var t,i,s;for(s=[],r=t=0,i=this.players.length-1;i>=0?i>=t:t>=i;r=i>=0?++t:--t)s.push(e());return s}.call(this),this.reserves=[4,4,4,4],this.goals=[0,0,0,0]}return t.prototype.checkEnd=function(){return this.goals.indexOf(4)},t.prototype.move=function(t){return this.again||(this.currentPlayer=(this.currentPlayer+1)%4),this.again=!1,this.players[this.currentPlayer].move(this),t.draw()},t.prototype.goAgain=function(){return this.again=!0},t.prototype.returnPiece=function(t){var i;return i=this.track[t],this.reserves[i]++,this.track[t]=null},t.prototype.deliverPiece=function(t){return this.goals[t]++},t.prototype.pbPosition=function(t,i){return(i-this.starts[t]+52)%52},t.prototype.acPosition=function(t,i){return(i+this.starts[t])%52},t.prototype.playerPieces=function(t){var i,s,e,o,r,n;for(o=[],r=this.track,n=i=0,s=r.length;s>i;n=++i)e=r[n],e===t&&o.push(n);return o.map(function(i){return function(s){return i.pbPosition(t,s)}}(this)).sort(function(t,i){return t-i})},t.prototype.advanceToken=function(t,i,s,e){var o,r,n,h;if(n=i+s,h=this.acPosition(t,i),o=this.acPosition(t,n),e)n===window.house_size?(this.deliverPiece(t),this.houses[t][i]=null):n<window.house_size&&null==this.houses[t][n]&&(this.houses[t][i]=null,this.houses[t][n]=t);else{if(this.track[h]!==t)return!1;if(r=this.doors[t],h===r||r>h&&h+s>r)o=s-(r-h)-1,o===window.house_size?(this.deliverPiece(t),this.track[h]=null):null==this.houses[t][o]&&(this.track[h]=null,this.houses[t][o]=t);else{if(this.track[o]===t)return!1;null!=this.track[o]&&this.returnPiece(o),this.track[h]=null,this.track[o]=t}}return!0},t}()});var extend=function(t,i){function s(){this.constructor=t}for(var e in i)hasProp.call(i,e)&&(t[e]=i[e]);return s.prototype=i.prototype,t.prototype=new s,t.__super__=i.prototype,t},hasProp={}.hasOwnProperty;$(function(){return window.Player=function(){function t(t,i){this.id=t,this.name=i,this.rolls=0}return t.prototype.hasStart=function(t){return t.reserves[this.id]>0},t.prototype.canStart=function(t,i){var s;return s=t.playerPieces(this.id),6===i&&this.hasStart(t)&&-1===s.indexOf(0)},t.prototype.hasExposed=function(t){return-1!==t.track.indexOf(this.id)},t.prototype.hasHoused=function(t){return-1!==t.houses[this.id].indexOf(this.id)},t.prototype.start=function(t){return this.hasStart(t)?(t.reserves[this.id]-=1,null!=t.track[t.starts[this.id]]&&t.returnPiece(t.starts[this.id]),t.track[t.starts[this.id]]=this.id):void 0},t.prototype.move=function(t){var i,s,e,o,r,n;if(o=t.die.roll(),6===o?this.rolls++:this.rolls=0,3!==this.rolls){if(n=t.playerPieces(this.id),this.canStart(t,o))return this.start(t),t.goAgain();if(this.hasExposed(t)){for(s=0,e=n.length;e>s&&(r=n[s],!t.advanceToken(this.id,r,o,!1));s++);if(6===o)return t.goAgain()}else if(this.hasHoused(t))return i=t.houses[this.id].indexOf(this.id),t.advanceToken(this.id,i,o,!0)}},t}(),window.SingleMindedPlayer=function(t){function i(){return i.__super__.constructor.apply(this,arguments)}return extend(i,t),i.prototype.move=function(t){var i,s,e;if(s=t.die.roll(),6===s?this.rolls++:this.rolls=0,3!==this.rolls)if(e=t.playerPieces(this.id),this.hasExposed(t)){if(i=e[e.length-1],t.advanceToken(this.id,i,s,!1),6===s)return t.goAgain()}else{if(this.canStart(t,s))return this.start(t),t.goAgain();if(this.hasHoused(t))return i=t.houses[this.id].indexOf(this.id),t.advanceToken(this.id,i,s,!0)}},i}(Player)}),$(function(){return window.BoardView=function(){function t(t,i){this.context=t,this.board=i,this.window_padding_top=30,this.window_padding_right=30,this.window_padding_bottom=30,this.window_padding_left=30,this.space_radius=10,this.space_padding_right=5,this.space_padding_bottom=5,this.goal_width=40,this.goal_height=30,this.h_text_offset=4,this.v_text_offset=5,this.line_height=20,this.tab_width=20,this.todolist_width=250,this.autorestart_width=20,this.colors={background:"#FFFFFF",space:"#000000",text:"#000000",players:["#FF0000","#00FF00","#00AAFF","#FFEE00"]}}return t.prototype.space_height=function(){return 2*this.space_radius},t.prototype.token_radius=function(){return this.space_radius-2},t.prototype.drawCircle=function(t,i,s,e){return this.context.fillStyle=e,this.context.beginPath(),this.context.arc(t,i,s,0,2*Math.PI),this.context.fill()},t.prototype.drawCheckBox=function(t,i,s,e){return this.context.strokeStyle=this.colors.space,this.context.strokeRect(t,i,s,s),e?(this.context.beginPath(),this.context.moveTo(t+s/4,i+s/4),this.context.lineTo(t+s/2,i+s/2),this.context.lineTo(t+5*s/4,i-s/4),this.context.lineTo(t+s/2,i+3*s/4),this.context.lineTo(t+s/4,i+s/4),this.context.fill()):void 0},t.prototype.clearScreen=function(){return this.context.fillStyle=this.colors.background,this.context.fillRect(0,0,window.innerWidth,window.innerHeight)},t.prototype.drawTrack=function(){var t,i,s,e,o,r,n,h,a,d;for(a=this.space_height()+this.space_padding_right,h=i=0;51>=i;h=++i)d=h*a+this.window_padding_left,this.drawCircle(d,this.window_padding_top,this.space_radius,this.colors.space);for(r=this.board.track,n=[],h=s=0,e=r.length;e>s;h=++s)o=r[h],null!=o?(t=this.colors.players[o],d=h*a+this.window_padding_left,n.push(this.drawCircle(d,this.window_padding_top,this.token_radius(),t))):n.push(void 0);return n},t.prototype.drawReserves=function(){var t,i,s,e,o,r,n,h,a,d,c;for(n=this.space_height()+this.space_padding_right,a=this.window_padding_top+this.space_height()+this.space_padding_bottom,c=a+this.space_radius/2,e=this.board.starts,o=[],s=t=0,i=e.length;i>t;s=++t)r=e[s],h=r*n+this.window_padding_left,this.drawCircle(h,a,this.space_radius,this.colors.players[s]),d=r*n+this.window_padding_left-this.h_text_offset,this.context.fillStyle=this.colors.text,o.push(this.context.fillText(this.board.reserves[s],d,c));return o},t.prototype.drawHouses=function(){var t,i,s,e,o,r,n,h,a,d,c,l,u,p,w,_,f,g,y,x;for(f=this.space_height()+this.space_padding_right,_=this.space_height()+this.space_padding_bottom,l=this.board.doors,p=[],c=e=0,r=l.length;r>e;c=++e){for(h=l[c],a=h*f+this.window_padding_left,u=this.board.houses[c],w=o=0,n=u.length;n>o;w=++o)d=u[w],g=w*_+this.window_padding_top+this.space_height()+this.space_padding_bottom,s=this.colors.players[c],this.drawCircle(a,g,this.space_radius,s),s=null!=d?this.colors.players[d]:this.colors.space,this.drawCircle(a,g,this.token_radius(),s);t=h*f+this.window_padding_left-this.goal_width/2,i=this.window_padding_top+7*this.space_height(),y=t+this.goal_width/2-this.h_text_offset,x=i+this.goal_height/2+this.h_text_offset,4===this.board.goals[c]?(this.context.fillStyle=this.colors.players[c],this.context.fillRect(t,i,this.goal_width,this.goal_height)):(this.context.strokeStyle=this.colors.players[c],this.context.strokeRect(t,i,this.goal_width,this.goal_height)),this.context.fillStyle=this.colors.text,p.push(this.context.fillText(this.board.goals[c],y,x))}return p},t.prototype.drawDie=function(){var t,i,s,e;return t=this.colors.players[this.board.currentPlayer],s=this.window_padding_left,e=window.innerHeight-this.window_padding_bottom,this.drawCircle(s,e,this.space_radius,t),i=this.board.die.history.splice(-1),this.context.fillStyle=this.colors.text,s=this.window_padding_left-this.h_text_offset,e=window.innerHeight-this.window_padding_bottom+this.v_text_offset,this.context.fillText(i,s,e),s+=this.space_height()+this.space_padding_right,this.context.fillText("Space to move, p to toggle play, r to restart",s,e),e-=this.line_height+this.space_radius,this.context.fillText("a to toggle autorestart",s,e),s=this.window_padding_left-this.space_radius,e=window.innerHeight-this.window_padding_bottom-4*this.space_radius,this.drawCheckBox(s,e,this.autorestart_width,window.autorestart)},t.prototype.drawTodoList=function(){var t,i,s,e,o,r,n,h,a;for(n=["Expose Decision Points","Create Strategies","Highlight last move (arrows maybe?)"],h=window.innerWidth-(this.todolist_width+this.window_padding_right),a=window.innerHeight-(this.window_padding_bottom+(n.length+1)*this.line_height),this.context.fillText("Todo List:",h-this.tab_width,a),r=[],o=i=0,e=n.length;e>i;o=++i)s=n[o],t=n.length-o,a=window.innerHeight-(this.window_padding_bottom+t*this.line_height),r.push(this.context.fillText(s,h,a));return r},t.prototype.drawStatistics=function(){var t,i,s,e,o,r,n,h,a,d;if(a=this.window_padding_left+this.space_radius,t=window.innerHeight-this.window_padding_bottom-6*this.space_radius,o=Math.max.apply(null,window.win_history),0!==o)for(h=this.board.players,r=s=0,e=h.length;e>s;r=++s)n=h[r],this.context.fillStyle=this.colors.players[r],i=100*window.win_history[r]/o,a+=this.space_radius,d=t-i,this.context.fillRect(a,d,this.space_radius,i);return a=this.window_padding_left+2*this.space_radius,this.context.strokeStyle="#AAAAAA",this.context.beginPath(),this.context.moveTo(a,t-100),this.context.lineTo(a+4*this.space_radius,t-100),this.context.moveTo(a,t-50),this.context.lineTo(a+4*this.space_radius,t-50),this.context.stroke(),this.context.fillStyle=this.colors.text,this.context.fillText(o,a+4*this.space_radius,t-100),this.context.fillText(o/2,a+4*this.space_radius,t-50)},t.prototype.draw=function(){return this.clearScreen(),this.context.font="12pt serif",this.drawTrack(),this.drawReserves(),this.drawHouses(),this.drawDie(),this.drawTodoList(),this.drawStatistics()},t}()});var extend=function(t,i){function s(){this.constructor=t}for(var e in i)hasProp.call(i,e)&&(t[e]=i[e]);return s.prototype=i.prototype,t.prototype=new s,t.__super__=i.prototype,t},hasProp={}.hasOwnProperty;$(function(){return window.CircleView=function(t){function i(t,s){this.track_radius=270,i.__super__.constructor.call(this,t,s)}return extend(i,t),i.prototype.calcCircleLocation=function(t,i){var s,e,o;return s={x:window.innerWidth/2,y:window.innerHeight/2},e=s.x+i*Math.cos(2*Math.PI*(t+2)/52),o=s.y+i*Math.sin(2*Math.PI*(t+2)/52),{x:e,y:o}},i.prototype.drawTrack=function(){var t,i,s,e,o,r,n,h;for(r=this.board.track,n=[],h=i=0,s=r.length;s>i;h=++i)o=r[h],e=this.calcCircleLocation(h,this.track_radius),this.drawCircle(e.x,e.y,this.space_radius,this.colors.space),null!=o?(t=this.colors.players[o],n.push(this.drawCircle(e.x,e.y,this.token_radius(),t))):n.push(void 0);return n},i.prototype.drawReserves=function(){var t,i,s,e,o,r,n,h,a;for(r=this.board.starts,n=[],e=t=0,i=r.length;i>t;e=++t)h=r[e],o=this.track_radius+this.space_height()+this.space_padding_bottom,s=this.calcCircleLocation(h,o),this.drawCircle(s.x,s.y,this.space_radius,this.colors.players[e]),this.context.fillStyle=this.colors.text,a={x:s.x-this.space_radius/2+1,y:s.y+this.space_radius/2},n.push(this.context.fillText(this.board.reserves[e],a.x,a.y));return n},i.prototype.drawHouses=function(){var t,i,s,e,o,r,n,h,a,d,c,l,u,p,w,_,f,g;for(_=this.space_height()+this.space_padding_bottom,l=this.board.doors,p=[],d=s=0,o=l.length;o>s;d=++s){for(h=l[d],u=this.board.houses[d],w=e=0,r=u.length;r>e;w=++e)a=u[w],c=this.track_radius-(w+1)*_,n=this.calcCircleLocation(h,c),i=this.colors.players[d],this.drawCircle(n.x,n.y,this.space_radius,i),null==a&&this.drawCircle(n.x,n.y,this.token_radius(),this.colors.space);c=this.track_radius-(this.board.houses[d].length+1.5)*_,n=this.calcCircleLocation(h,c),t={x:n.x-this.goal_width/2,y:n.y-this.goal_height/2},g={x:t.x+this.goal_width/2-this.h_text_offset,y:t.y+this.goal_height/2+this.v_text_offset},f=4===this.board.goals[d]?"fill":"stroke",this.context[f+"Style"]=this.colors.players[d],this.context[f+"Rect"](t.x,t.y,this.goal_width,this.goal_height),this.context.fillStyle=this.colors.text,p.push(this.context.fillText(this.board.goals[d],g.x,g.y))}return p},i}(BoardView)}),$(function(){var t,i,s,e,o,r,n,h,a,d;return i=document.getElementById("board"),s=i.getContext("2d"),o=new Player(0,"Fred"),r=new Player(1,"Fred"),n=new SingleMindedPlayer(2,"Fred"),h=new Player(3,"Fred"),e=new Die(6),t=new Board([o,r,n,h],e,s),d=new CircleView(s,t),a=function(){return i.width=window.innerWidth,i.height=window.innerHeight,d.draw()},window.addEventListener("resize",a,!1),a(),window.restart=function(){return t=new Board([o,r,n,h],e,s),d.board=t,d.draw()},window.move=function(){return t.move(d),-1!==t.checkEnd()?(window.win_history[t.checkEnd()]++,d.draw(),autorestart?(window.clearInterval(window.autoplay),window.autoplay=null,window.setTimeout(function(){return restart(),window.autoplay=window.setInterval(move,20)},1e3)):(window.clearInterval(window.autoplay),window.autoplay=null)):void 0},window.displayHouses=function(){return console.log(t.houses)},$(window).on("keyup",function(t){switch(t.which){case 32:return window.move();case 80:return null==window.autoplay?window.autoplay=window.setInterval(move,20):(window.clearInterval(window.autoplay),window.autoplay=null);case 82:return window.restart();case 65:return window.autorestart=!window.autorestart,d.draw()}})});