$(function(){return window.Die=function(){function t(t){this.numSides=t,this.history=[]}return t.prototype.roll=function(){var t;return t=Math.floor(Math.random()*this.numSides)+1,this.history.push(t),t},t.prototype.recentRolls=function(){return this.history.slice(-20,-1)},t}()});var bind=function(t,i){return function(){return t.apply(i,arguments)}};$(function(){return window.Board=function(){function t(t,i,s){var e;this.players=t,this.die=i,this.context=s,this.playerPieces=bind(this.playerPieces,this),this.currentPlayer=3,this.again=!1,this.track=function(){var t,i;for(i=[],e=t=0;51>=t;e=++t)i.push(null);return i}(),this.doors=[50,24,11,37],this.starts=[0,26,13,39],this.houses=[[null,null,null,null,null],[null,null,null,null,null],[null,null,null,null,null],[null,null,null,null,null]],this.reserves=[4,4,4,4],this.goals=[0,0,0,0]}return t.prototype.checkEnd=function(){return-1!==this.goals.indexOf(4)},t.prototype.move=function(t){return this.again||(this.currentPlayer=(this.currentPlayer+1)%4),this.again=!1,this.players[this.currentPlayer].move(this),t.draw()},t.prototype.goAgain=function(){return this.again=!0},t.prototype.returnPiece=function(t){var i;return i=this.track[t],this.reserves[i]++,this.track[t]=null},t.prototype.deliverPiece=function(t){return this.goals[t]++},t.prototype.pbPosition=function(t,i){return(i-this.starts[t])%52},t.prototype.acPosition=function(t,i){return(i+this.starts[t])%52},t.prototype.playerPieces=function(t){var i,s,e,o,r,n;for(o=[],r=this.track,n=i=0,s=r.length;s>i;n=++i)e=r[n],e===t&&o.push(n);return o.map(function(i){return function(s){return i.pbPosition(t,s)}}(this))},t.prototype.advanceToken=function(t,i,s,e){var o,r,n,h,a;if(h=i+s,a=this.acPosition(t,i),o=this.acPosition(t,h),console.log("Advancing from "+i+" by "+s),e){if(console.log("Moving in house!"),5===h)return this.deliverPiece(t),this.houses[t][i]=null;if(5>h&&null==this.houses[t][h])return this.houses[t][i]=null,this.houses[t][h]=t}else if(this.track[a]===t)if(console.log("Piece ownership verified"),r=this.doors[t],a===r||r>a&&a+s>r){if(n=s-(r-a)-1,null==this.houses[t][n])return this.track[a]=null,this.houses[t][n]=t}else if(console.log("Just a mundane move"),console.log(a+" -> "+o),this.track[o]!==t)return console.log("Not stepping on own foot"),null!=this.track[o]&&this.returnPiece(o),console.log("Actually moving now!"),this.track[a]=null,this.track[o]=t,console.log(this.track[o])},t}()}),$(function(){return window.Player=function(){function t(t,i){this.id=t,this.name=i}return t.prototype.hasStart=function(t){return t.reserves[this.id]>0},t.prototype.hasExposed=function(t){return-1!==t.track.indexOf(this.id)},t.prototype.hasHoused=function(t){return-1!==t.houses[this.id].indexOf(this.id)},t.prototype.start=function(t){return this.hasStart(t)?(t.reserves[this.id]-=1,null!=t.track[t.starts[this.id]]&&t.returnPiece(t.starts[this.id]),t.track[t.starts[this.id]]=this.id):void 0},t.prototype.move=function(t){var i,s,e;return s=t.die.roll(),e=t.playerPieces(this.id),6===s?(this.start(t),t.goAgain()):this.hasExposed(t)?(i=e[0],t.advanceToken(this.id,i,s,!1)):this.hasHoused(t)?(i=t.houses[this.id].indexOf(this.id),t.advanceToken(this.id,i,s,!0)):console.log("Do Nothing")},t}()}),$(function(){return window.BoardView=function(){function t(t,i){this.context=t,this.board=i,this.window_padding_top=30,this.window_padding_right=30,this.window_padding_bottom=30,this.window_padding_left=30,this.space_radius=10,this.space_padding_right=5,this.space_padding_bottom=5,this.goal_width=40,this.goal_height=30,this.h_text_offset=4,this.v_text_offset=5,this.line_height=20,this.tab_width=20,this.todolist_width=300,this.colors={background:"#FFFFFF",space:"#000000",text:"#000000",players:["#FF0000","#00FF00","#00AAFF","#FFFF00"]}}return t.prototype.space_height=function(){return 2*this.space_radius},t.prototype.token_radius=function(){return this.space_radius-2},t.prototype.drawCircle=function(t,i,s,e){return this.context.fillStyle=e,this.context.beginPath(),this.context.arc(t,i,s,0,2*Math.PI),this.context.fill()},t.prototype.clearScreen=function(){return this.context.fillStyle=this.colors.background,this.context.fillRect(0,0,window.innerWidth,window.innerHeight)},t.prototype.drawTrack=function(){var t,i,s,e,o,r,n,h,a,l;for(a=this.space_height()+this.space_padding_right,h=i=0;51>=i;h=++i)l=h*a+this.window_padding_left,this.drawCircle(l,this.window_padding_top,this.space_radius,this.colors.space);for(r=this.board.track,n=[],h=s=0,e=r.length;e>s;h=++s)o=r[h],null!=o?(t=this.colors.players[o],l=h*a+this.window_padding_left,n.push(this.drawCircle(l,this.window_padding_top,this.token_radius(),t))):n.push(void 0);return n},t.prototype.drawReserves=function(){var t,i,s,e,o,r,n,h,a,l,c;for(n=this.space_height()+this.space_padding_right,a=this.window_padding_top+this.space_height()+this.space_padding_bottom,c=a+this.space_radius/2,e=this.board.starts,o=[],s=t=0,i=e.length;i>t;s=++t)r=e[s],h=r*n+this.window_padding_left,this.drawCircle(h,a,this.space_radius,this.colors.players[s]),l=r*n+this.window_padding_left-this.h_text_offset,this.context.fillStyle=this.colors.text,o.push(this.context.fillText(this.board.reserves[s],l,c));return o},t.prototype.drawHouses=function(){var t,i,s,e,o,r,n,h,a,l,c,d,u,p,w,_,g,f,y,x;for(g=this.space_height()+this.space_padding_right,_=this.space_height()+this.space_padding_bottom,d=this.board.doors,p=[],c=e=0,r=d.length;r>e;c=++e){for(h=d[c],a=h*g+this.window_padding_left,u=this.board.houses[c],w=o=0,n=u.length;n>o;w=++o)l=u[w],f=w*_+this.window_padding_top+this.space_height()+this.space_padding_bottom,s=this.colors.players[c],this.drawCircle(a,f,this.space_radius,s),s=null!=l?this.colors.players[l]:this.colors.space,this.drawCircle(a,f,this.token_radius(),s);t=h*g+this.window_padding_left-this.goal_width/2,i=this.window_padding_top+7*this.space_height(),y=t+this.goal_width/2-this.h_text_offset,x=i+this.goal_height/2+this.h_text_offset,4===this.board.goals[c]?(this.context.fillStyle=this.colors.players[c],this.context.fillRect(t,i,this.goal_width,this.goal_height)):(this.context.strokeStyle=this.colors.players[c],this.context.strokeRect(t,i,this.goal_width,this.goal_height)),this.context.fillStyle=this.colors.text,p.push(this.context.fillText(this.board.goals[c],y,x))}return p},t.prototype.drawDie=function(){var t,i,s,e;return t=this.colors.players[this.board.currentPlayer],s=this.window_padding_left,e=window.innerHeight-this.window_padding_bottom,this.drawCircle(s,e,this.space_radius,t),i=this.board.die.history.splice(-1),this.context.fillStyle=this.colors.text,s=this.window_padding_left-this.h_text_offset,e=window.innerHeight-this.window_padding_bottom+this.v_text_offset,this.context.fillText(i,s,e),s+=this.space_height()+this.space_padding_right,this.context.fillText("Space to move, p to toggle play, r to restart",s,e)},t.prototype.drawTodoList=function(){var t,i,s,e,o,r,n,h,a;for(n=["Fix goal and text spacing on the circle view","Expose a player-centric board to each player","Find all current active pieces","Expose Decision Points","Create Strategies","Highlight last move (arrows maybe?)"],h=window.innerWidth-(this.todolist_width+this.window_padding_right),a=window.innerHeight-(this.window_padding_bottom+(n.length+1)*this.line_height),this.context.fillText("Todo List:",h-this.tab_width,a),r=[],o=i=0,e=n.length;e>i;o=++i)s=n[o],t=n.length-o,a=window.innerHeight-(this.window_padding_bottom+t*this.line_height),r.push(this.context.fillText(s,h,a));return r},t.prototype.draw=function(){return this.clearScreen(),this.context.font="12pt serif",this.drawTrack(),this.drawReserves(),this.drawHouses(),this.drawDie(),this.drawTodoList()},t}()});var extend=function(t,i){function s(){this.constructor=t}for(var e in i)hasProp.call(i,e)&&(t[e]=i[e]);return s.prototype=i.prototype,t.prototype=new s,t.__super__=i.prototype,t},hasProp={}.hasOwnProperty;$(function(){return window.CircleView=function(t){function i(t,s){this.track_radius=270,i.__super__.constructor.call(this,t,s)}return extend(i,t),i.prototype.calcCircleLocation=function(t,i){var s,e,o;return s={x:window.innerWidth/2,y:window.innerHeight/2},e=s.x+i*Math.cos(2*Math.PI*t/52),o=s.y+i*Math.sin(2*Math.PI*t/52),{x:e,y:o}},i.prototype.drawTrack=function(){var t,i,s,e,o,r,n,h;for(r=this.board.track,n=[],h=i=0,s=r.length;s>i;h=++i)o=r[h],e=this.calcCircleLocation(h,this.track_radius),this.drawCircle(e.x,e.y,this.space_radius,this.colors.space),null!=o?(t=this.colors.players[o],n.push(this.drawCircle(e.x,e.y,this.token_radius(),t))):n.push(void 0);return n},i.prototype.drawReserves=function(){var t,i,s,e,o,r,n,h,a;for(r=this.board.starts,n=[],e=t=0,i=r.length;i>t;e=++t)h=r[e],o=this.track_radius+this.space_height()+this.space_padding_bottom,s=this.calcCircleLocation(h,o),this.drawCircle(s.x,s.y,this.space_radius,this.colors.players[e]),this.context.fillStyle=this.colors.text,a=this.calcCircleLocation(h,o-this.v_text_offset),n.push(this.context.fillText(this.board.reserves[e],a.x,a.y));return n},i.prototype.drawHouses=function(){var t,i,s,e,o,r,n,h,a,l,c,d,u,p,w,_;for(w=this.space_height()+this.space_padding_bottom,c=this.board.doors,u=[],a=i=0,e=c.length;e>i;a=++i){for(n=c[a],d=this.board.houses[a],p=s=0,o=d.length;o>s;p=++s)h=d[p],l=this.track_radius-(p+1)*w,r=this.calcCircleLocation(n,l),t=this.colors.players[a],this.drawCircle(r.x,r.y,this.space_radius,t),t=null!=h?this.colors.players[h]:this.colors.space,this.drawCircle(r.x,r.y,this.token_radius(),t);l=this.track_radius-7*w,r=this.calcCircleLocation(n,l),_={x:r.x+this.goal_width/2-this.h_text_offset,y:r.y+this.goal_height/2-this.h_text_offset},4===this.board.goals[a]?(this.context.fillStyle=this.colors.players[a],this.context.fillRect(r.x,r.y,this.goal_width,this.goal_height)):(this.context.strokeStyle=this.colors.players[a],this.context.strokeRect(r.x,r.y,this.goal_width,this.goal_height)),this.context.fillStyle=this.colors.text,u.push(this.context.fillText(this.board.goals[a],_.x,_.y))}return u},i}(BoardView)}),$(function(){var t,i,s,e,o,r,n,h,a,l,c;return s=document.getElementById("board"),e=s.getContext("2d"),r=new Player(0,"Fred"),n=new Player(1,"Fred"),h=new Player(2,"Fred"),a=new Player(3,"Fred"),o=new Die(6),i=new Board([r,n,h,a],o,e),c=new CircleView(e,i),t=null,l=function(){return s.width=window.innerWidth,s.height=window.innerHeight,c.draw()},window.addEventListener("resize",l,!1),l(),window.move=function(){return i.move(c),i.checkEnd()?(window.clearInterval(t),t=null):void 0},window.restart=function(){return i=new Board([r,n,h,a],o,e),c.board=i,c.draw()},window.displayHouses=function(){return console.log(i.houses)},$(window).on("keyup",function(i){return 32===i.which?window.move():80===i.which?(console.log("p pressed"),null==t?t=window.setInterval(move,20):(window.clearInterval(t),t=null)):82===i.which?window.restart():void 0})});