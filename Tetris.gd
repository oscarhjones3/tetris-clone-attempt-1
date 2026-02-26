extends TileMapLayer
#piece position coordinates, for all rotations

var L0: Array = [Vector2i(0,1),Vector2i(0,2),Vector2i(1,1),Vector2i(2,1)]
var L90: Array = [Vector2i(0,0),Vector2i(1,0),Vector2i(1,1),Vector2i(1,2)]
var L180: Array = [Vector2i(0,2),Vector2i(1,2),Vector2i(2,1),Vector2i(2,2)]
var L270: Array = [Vector2i(1,0),Vector2i(1,1),Vector2i(1,2),Vector2i(2,2)]

var J0: Array = [Vector2i(0,1),Vector2i(1,1),Vector2i(2,1),Vector2i(2,2)]
var J90: Array = [Vector2i(0,2),Vector2i(1,0),Vector2i(1,1),Vector2i(1,2)]
var J180: Array = [Vector2i(0,0),Vector2i(0,1),Vector2i(1,1),Vector2i(2,1)]
var J270: Array = [Vector2i(1,0),Vector2i(1,1),Vector2i(1,2),Vector2i(2,0)]

var S0: Array = [Vector2i(0,1),Vector2i(1,0),Vector2i(1,1),Vector2i(2,0)]
var S90: Array = [Vector2i(1,0),Vector2i(1,1),Vector2i(2,1),Vector2i(2,2)]
var S180: Array = [Vector2i(0,2),Vector2i(1,1),Vector2i(1,2),Vector2i(2,1)]
var S270: Array = [Vector2i(0,0),Vector2i(0,1),Vector2i(1,1),Vector2i(1,2)]

var Z0: Array = [Vector2i(0,0),Vector2i(1,0),Vector2i(1,1),Vector2i(2,1)]
var Z90: Array = [Vector2i(1,1),Vector2i(1,2),Vector2i(2,0),Vector2i(2,1)]
var Z180: Array = [Vector2i(0,1),Vector2i(1,1),Vector2i(1,2),Vector2i(2,2)]
var Z270: Array = [Vector2i(0,1),Vector2i(0,2),Vector2i(1,0),Vector2i(1,1)]

var O0: Array = [Vector2i(1,0),Vector2i(2,0),Vector2i(1,1),Vector2i(2,1)]
var O90: Array = [Vector2i(1,0),Vector2i(2,0),Vector2i(1,1),Vector2i(2,1)]
var O180: Array = [Vector2i(1,0),Vector2i(2,0),Vector2i(1,1),Vector2i(2,1)]
var O270: Array = [Vector2i(1,0),Vector2i(2,0),Vector2i(1,1),Vector2i(2,1)]

var T0: Array = [Vector2i(0,1),Vector2i(1,1),Vector2i(1,2),Vector2i(2,1)]
var T90: Array = [Vector2i(0,1),Vector2i(1,0),Vector2i(1,1),Vector2i(1,2)]
var T180: Array = [Vector2i(0,1),Vector2i(1,0),Vector2i(1,1),Vector2i(2,1)]
var T270: Array = [Vector2i(1,0),Vector2i(1,1),Vector2i(1,2),Vector2i(2,1)]

var I0: Array = [Vector2i(0,2),Vector2i(1,2),Vector2i(2,2),Vector2i(3,2)]
var I90: Array = [Vector2i(2,0),Vector2i(2,1),Vector2i(2,2),Vector2i(2,3)]
var I180: Array = [Vector2i(0,2),Vector2i(1,2),Vector2i(2,2),Vector2i(3,2)]
var I270: Array = [Vector2i(2,0),Vector2i(2,1),Vector2i(2,2),Vector2i(2,3)]

var L: Array = [L0,L90,L180,L270]
var J: Array = [J0, J90, J180, J270]
var S: Array = [S0, S90, S180, S270]
var Z: Array = [Z0, Z90, Z180, Z270]
var O: Array = [O0,O90,O180,O270]
var T: Array = [T0, T90, T180, T270]
var I: Array = [I0, I90, I180, I270]
#board variables

#pieces
var piece
var next_piece
var rot : int = 0
var active_piece : Array
var pieces = [L,J,S,Z,O,T,I]
var falls = 0

const startPos = [Vector2i(4,0),Vector2i(4,0),Vector2i(4,1),Vector2i(4,1),Vector2i(4,1),Vector2i(4,0),Vector2i(4,-1)]
const nextPos = Vector2i(13,4)
var cur : Vector2i
var dropSpeed : float = 1
var dropTable : Array = [48,43,38,33,28,23,18,13,8,6,5,5,5,4,4,4,3,3,3,2,2,2,2,2,2,2,2,2,2,1]
var sd = true
var moveTime = [6,6,60]
var moveTicks = [0,0,0]
var ARR : float = 1
var Directions = [Vector2i(-1,0), Vector2i(1,0), Vector2i(0,1)]



#tilevars
var tile_id = 1
var pieceAtlas : Vector2i
var nextAtlas : Vector2i
var pieceAtlases = [Vector2i(1,1),Vector2i(0,1),Vector2i(0,1),Vector2i(1,1),Vector2i(1,0),Vector2i(1,0),Vector2i(1,0)]



#gamevars
signal scoreUpdate(p : int,l:int, li:int)
signal gameOver

var stopGame :bool = false
var paused : bool = false

var lines:int = 0
var points : int = 0
var pName : String

var records = GameStart.records
var highScoreNames = GameStart.recordNames 
var level = GameStart.level

var player = GameStart.player

func _ready() -> void:
	seed(1);
	newGame()
	#records = []
	#highScoreNames = []
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if(not paused):
		if Input.is_action_just_pressed("ui_left"):
			move(Vector2i(-1,0))
			moveTicks[0] = -10
		if Input.is_action_just_pressed("ui_right"):
			move(Vector2i(1,0))
			moveTicks[1] = -10
	if Input.is_action_just_released("ui_down"):
		sd = true

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
			if(stopGame):
				get_tree().change_scene_to_file("res://menu_screen.tscn")
			elif(paused):
				paused = false
				get_parent().get_node("PauseScreen").visible = false
			else:
				paused = true
				get_parent().get_node("PauseScreen").visible = true
	if(not paused):
		if Input.is_action_just_pressed("x"):
			rotator(1)
		if Input.is_action_just_pressed("z"):
			rotator(3)
		if Input.is_action_pressed("ui_left"):
			moveTicks[0] += ARR
		elif Input.is_action_pressed("ui_right"):
			moveTicks[1] += ARR
		elif Input.is_action_pressed("ui_down"):
			if sd == true: 
				moveTicks[2] += dropTable[level]/2
		emit_signal("scoreUpdate", points, level, lines)
		moveTicks[2] += dropSpeed
		for i in range (0,3):
			if(moveTicks[i] > moveTime[i]):
				move(Directions[i])
				moveTicks[i] = 0
				if(Input.is_action_pressed("ui_down")&& sd== true):
					points += 1

func scoreChecker():
	var isClear = true
	var clearedLines : Array = []
	for y in range(20,1,-1):
		isClear = true
		for x in range(1,11):
			if(get_parent().get_node("Board").get_cell_atlas_coords(Vector2i(x,y)) == Vector2i(2,0)):
				isClear = false
		if(isClear):
			clearedLines.append(y)
	score(clearedLines)
	if clearedLines.size() > 0:
		return true
	else:
		return false

func score(c: Array):
	var clears = c
	var amount = clears.size()
	var bases = [40,100,300,1200]
	if(amount > 0):
		lines += amount
		points += bases[amount-1] * (level +1)
		paused = true
		
		for x in range(1,6):
			if amount > 3: 
				get_parent().get_node("Board").set_cell(Vector2i(6-x,clears[3]), level % 10, Vector2i(2,0))
				get_parent().get_node("Board").set_cell(Vector2i(5+x,clears[3]), level % 10, Vector2i(2,0))
			if amount > 2: 
				get_parent().get_node("Board").set_cell(Vector2i(6-x,clears[2]), level% 10, Vector2i(2,0))
				get_parent().get_node("Board").set_cell(Vector2i(5+x,clears[2]), level% 10, Vector2i(2,0))
			if amount > 1: 
				get_parent().get_node("Board").set_cell(Vector2i(6-x,clears[1]), level, Vector2i(2,0))
				get_parent().get_node("Board").set_cell(Vector2i(5+x,clears[1]), level% 10, Vector2i(2,0))
			if amount > 0: 
				get_parent().get_node("Board").set_cell(Vector2i(6-x,clears[0]), level% 10, Vector2i(2,0))
				get_parent().get_node("Board").set_cell(Vector2i(5+x,clears[0]), level% 10, Vector2i(2,0))
			await get_tree().create_timer(0.1).timeout
	
		for i in range (0,amount):
			for y in range(clears.max(),1,-1):
				if(blankRow(y-1) && y < clears.min()):
					continue
				if (y != clears.max()):
					for x in range(1,11):
						if(not empty(Vector2i(x,y-1))):
							get_parent().get_node("Board").set_cell(Vector2i(x,y),level% 10,get_parent().get_node("Board").get_cell_atlas_coords(Vector2i(x,y-1)))
							get_parent().get_node("Board").set_cell(Vector2i(x,y-1),level% 10,Vector2i(2,0))
				if (y == clears.max() && blankRow(clears.max())):
					for x in range(1,11):
						if(not empty(Vector2i(x,y-1))):
							get_parent().get_node("Board").set_cell(Vector2i(x,y),level% 10,get_parent().get_node("Board").get_cell_atlas_coords(Vector2i(x,y-1)))
							get_parent().get_node("Board").set_cell(Vector2i(x,y-1),level% 10,Vector2i(2,0))
		if(lines >= (10 + (level * 10))):
			levelUp()
		paused = false
		createPiece(piece)
	
func saveRecords():
	var saved = false
	
	for i in range(0,records.size()):
		if(points > records[i]):
			if(not saved):
				records.insert(i,points)
				highScoreNames.insert(i,pName)
				saved = true
	if(not saved && records.size() <= 10):
		records.append(points)
		highScoreNames.append(pName)
	GameStart.records = records
	GameStart.recordNames = highScoreNames
	GameStart.writeSave()
	
func newGame():
	get_parent().get_node("HUD/gameOver").text = ""
	get_parent().get_node("HUD/nameEnter").hide()
	lines = 0
	points = 0
	level = GameStart.level
	moveTime[2]=dropTable[level]
	piece = pick_piece()
	next_piece = pick_piece()
	nextAtlas = pieceAtlases[pieces.find(next_piece)]
	createPiece(piece)

func endGame():
	lock()
	var colors : Array = [Vector2i(0,1),Vector2i(1,1), Vector2i(1,0)]
	var alt = 0
	for y in range(20,0,-1):
		for x in range(1,11):
			get_parent().get_node("Board").set_cell(Vector2i(x,y),level% 10,colors[alt])
			await get_tree().create_timer(0.005).timeout
		alt = (alt + 1) % 3
	for y in range(20,0,-1):
		for x in range(1,11):
			get_parent().get_node("Board").set_cell(Vector2i(x,y),level% 10,Vector2i(2,0))
		await get_tree().create_timer(0.02).timeout
	
	get_parent().get_node("HUD/gameOver").text = "Game Over"
	get_parent().get_node("HUD/nameEnter").show()
	get_parent().get_node("HUD/nameEnter").edit()
	await get_parent().get_node("HUD/nameEnter").text_submitted
	pName = get_parent().get_node("HUD/nameEnter").text
	stopGame = true
	emit_signal("gameOver")
	saveRecords()
	
func levelUp():
	level += 1
	moveTime[2] = dropTable[level]
	for y in range(20,0,-1):
		for x in range (1,11):
			var co = get_parent().get_node("Board").get_cell_atlas_coords(Vector2i(x,y))
			get_parent().get_node("Board").set_cell(Vector2i(x,y),level % 10,co)

func pick_piece():
	var p = randi() % 7
	return pieces.get(p)
	
func createPiece(p):
	paused = true
	await get_tree().create_timer(0.25).timeout
	paused = false
	rot = 0
	cur = startPos[pieces.find(p)]
	moveTicks = [0,0,0]
	draw(p[rot],startPos[pieces.find(p)],pieceAtlases[pieces.find(piece)])
	draw(piece[0],nextPos,Vector2i(-1,-1))
	draw(next_piece[0],nextPos,pieceAtlases[pieces.find(next_piece)])
	if(paused == false):
		if(player == 1):
			
			makeMove(COM1())
		if(player == 2):
			makeMove(COM2())
		if(player == 3):
			makeMove(COM3())
	
func move(dir:Vector2i):
	if(canMove(dir)):
		draw(piece[rot],cur,Vector2i(-1,-1))
		cur.x += dir.x
		cur.y += dir.y
		draw(piece[rot],cur,pieceAtlases[pieces.find(piece)])
	elif(dir == Directions[2]):
		if(cur.y == 1):
			endGame()
			paused = true
		lock()
		piece = next_piece
		pieceAtlas = nextAtlas
		next_piece = pick_piece()
		nextAtlas = pieceAtlases[pieces.find(next_piece)]
		cur = startPos[pieces.find(piece)]
		if not paused:
			createPiece(piece)

func draw(p, coord, atlas):
	for i in p:
		set_cell(coord + i,level% 10,atlas)
	pass

func rotator(clock):
	if (canRotate(clock)):
		draw(piece[rot],cur,Vector2i(-1,-1))
		rot = (rot + clock) % 4
		draw(piece[rot],cur,pieceAtlases[pieces.find(piece)])

func lock():
		if(Input.is_action_pressed("ui_down")):
			sd = false
		draw(piece[rot],cur,Vector2i(-1,-1))
		for i in piece[rot]:
			get_parent().get_node("Board").set_cell(i+cur,level % 10,pieceAtlases[pieces.find(piece)])
		scoreChecker()

func canMove(dir:Vector2i):
	var cm = true
	for i in piece.get(rot):
		if(not empty(i + cur + dir)):
			cm = false
	return cm
	
func canRotate(d):
	var cr = true
	for i in piece.get((rot+d)%4):
		if(not empty(i+cur)):
			cr = false
	return cr

func empty(pos):
	if(get_parent().get_node("Board").get_cell_atlas_coords(pos) != Vector2i(2,0)):
		return false
	elif(get_parent().get_node("Board").get_cell_atlas_coords(pos) == Vector2i(2,0)):
		return true

func blankRow(y):
		for x in range(1,11):
			if(not empty(Vector2i(x,y))):
				return false
		return true

func COM1():
	var board :Array
	var moves : Array
	#representing the board as an array of arrays
	for y in range(1,21):
		var row = []
		for x in range(1,11):
			if(get_parent().get_node("Board").get_cell_atlas_coords(Vector2i(x,y)) == Vector2i(2,0)):
				row.append(0)
			else:
				row.append(1)
		board.append(row)
	
	#create an array of all possible moves
	for r in range (0,4):
		var minRight = 0 - minMaxDir(piece[r],"x",false)
		var maxRight = 10 - minMaxDir(piece[r],"x",true)
		for x in range(minRight,maxRight):
			moves.append([x,r])
	var results = []
	var bestMove = 10
	for m in moves:
		results.append(COM1Score(boardAfter(m,board.duplicate())))
	for r in results:
		if(r < results[bestMove]):
			bestMove = results.find(r)
	#print(moves)
	#print(results)
	print(moves[bestMove])
	return(moves[bestMove])
func COM2():
	var board :Array
	var moves : Array
	#representing the board as an array of arrays
	for y in range(1,21):
		var row = []
		for x in range(1,11):
			if(get_parent().get_node("Board").get_cell_atlas_coords(Vector2i(x,y)) == Vector2i(2,0)):
				row.append(0)
			else:
				row.append(1)
		board.append(row)
	
	#create an array of all possible moves
	for r in range (0,4):
		var minRight = 0 - minMaxDir(piece[r],"x",false)
		var maxRight = 10 - minMaxDir(piece[r],"x",true)
		for x in range(minRight,maxRight):
			moves.append([x,r])
	var results = []
	var bestMove = 10
	for m in moves:
		results.append(COM2Score(boardAfter(m,board.duplicate())))
	for r in results:
		if(r > results[bestMove]):
			bestMove = results.find(r)
	print(moves)
	print(results)
	print(moves[bestMove])
	return(moves[bestMove])
	
func COM3():
	pass

func makeMove(m:Array):
	rotator(m[1] - rot)
	for i in range(0,abs(cur.x - m[0])+1):
		await get_tree().create_timer(0.05).timeout
		if(cur.x > m[0]):
			move(Vector2i(-1,0))
		else:
			move(Vector2i(1,0))

func minMaxDir(p:Array,d:String,Maximum:bool): 
	var M : int
	if(Maximum):
		M = 0
		for i in range(0,4):
			if(d == "x"):
				if(p[i].x > M):
					M = p[i].x
			elif(d == "y"):
				if(p[i].y > M):
					M = p[i].y
		return M
	else:
		M = 3
		for i in range(0,4):
			if(d == "x"):
				if(p[i].x < M):
					M = p[i].x
			elif(d == "y"):
				if(p[i].y < M):
					M = p[i].y
		return M

func boardAfter(m:Array,b:Array):
	var board = b
	var newBoard = []
	for y in range(0,20):
		var blank = []
		for x in range(0,10):
			blank.append(0)
		newBoard.append(blank)
	
	#find where the piece stops moving
	var minY = 19 - minMaxDir(piece[m[1]],"y",true)
	var canMoveDown = true
	var stop = minY
	for y in range(0,minY):
		if(canMoveDown):
			for i in piece[m[1]]:
				if(b[i.y + y + 1][i.x + m[0]] == 1):
					canMoveDown = false
					stop = y
	#draw the piece onto the board
	for y in range(0,20):
		for x in range(0,10):
			newBoard[y][x] = board[y][x]
	for i in piece[m[1]]:
		newBoard[stop + i.y][i.x + m[0]] = 1
	#print(newBoard)
	return newBoard

func COM1Score(board:Array):
	var newBoard = board
	var columnHeights = []
	var lineClears : float = 0
	
	for x in range(0,10):
		var height = 0
		for y in range(19,-1,-1):
			if(newBoard[y][x] == 1):
				height = 20-y
		columnHeights.append(height)
	# check for cleared lines
	for y in range(0,20):
		var isClear = true
		for x in range(0,10):
			if(newBoard[y][x] == 0):
				isClear = false
		if(isClear):
			lineClears += 1
	var columnTotals:float = 0.0
	var tippyTop = 0
	for i in columnHeights:
		columnTotals += i
		if i > tippyTop:
			tippyTop = i
	var colAvg:float = columnTotals / columnHeights.size()
	colAvg -= lineClears
	var Score = colAvg + tippyTop - (3*lineClears)
	return Score
func COM2Score(board:Array):
	var cols : Array = []
	var wells = []
	
	
	var clears = 0
	var avgHeight : float = 0
	var maxHeight = 0
	var holes = 0
	var colBumps = 0
	var rowBumps = 0
	var wellAvg : float
	var numWells = 0
	#find line clears
	var clearArray = []
	for y in range(0,20):
		var isClear = true
		for x in range(0,10):
			if(board[y][x] == 0):
				isClear = false
		if(isClear):
			clears += 1
			board[y] = [0,0,0,0,0,0,0,0,0,0]
			clearArray.append(y)
	for i in clearArray:
		board.remove_at(i)
		board.insert(0,[0,0,0,0,0,0,0,0,0,0])
			
			
	#find AVG and MAX board height
	var totalHeight : float = 0
	for x in range(0,10):
		var height = 0
		for y in range(19,-1,-1):
			if(board[y][x] == 1):
				height = 20 - y
		totalHeight += height
		cols.append(height)
		if(height > maxHeight):
			maxHeight = height
	avgHeight = totalHeight / 10
	
	#find holes (empty with a full above)
	for x in range(0,10):
		for y in range(0,19):
			if(board[y][x] == 1 && board[y+1][x] == 0):
				holes += 1
			
	#bumps in cols
	for x in range(0,10):
		for y in range(19,20-cols[x],-1):
			if((board[y][x]) != (board[y-1][x])):
				colBumps += 1
	
	#bumps in rows
	for y in range(0,20):
		for x in range(0,9):
			if(board[y][x] != board[y][x+1]):
				rowBumps += 1
				
	#find wells
	if(cols[0] < cols[1]):
		if(cols[1] - cols[0] > 2):
			numWells += 1
		wells.append(cols[1]-cols[0])
	else:
		wells.append(0)
	for x in range(1,9):
		var lDif = cols[x-1] - cols[x]
		var RDif = cols[x+1] - cols[x]
		if(lDif > 0 && RDif > 0):
			if(lDif > RDif):
				wells.append(lDif)
			else:
				wells.append(RDif)
		else:
			wells.append(0)
		if(lDif > 2 && RDif > 2):
			numWells += 1
	if(cols[9] < cols[8]):
		if(cols[8] - cols[9] > 2):
			numWells += 1
		wells.append(cols[8]-cols[9])
	else:
		wells.append(0)
	for w in wells:
		wellAvg += w
	wellAvg = wellAvg / wells.size()
	
	#Apply weights to these values and calculate final score
	#roughly == lineClears - everything else
	var clearWeights = [0,0,25,45,12500]
	var Score = 0
	
	Score += 3 * clearWeights[clears]
	Score -= 2 * avgHeight
	Score -= maxHeight
	Score -= 5000 * holes
	Score -= (colBumps + rowBumps)
	Score -= 2 * wellAvg
	Score -= 4 * abs((1-numWells))
	return Score
