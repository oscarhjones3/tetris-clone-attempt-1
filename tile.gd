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
var I90: Array = [Vector2i(1,0),Vector2i(1,1),Vector2i(1,2),Vector2i(1,3)]
var I180: Array = [Vector2i(0,1),Vector2i(1,1),Vector2i(2,1),Vector2i(3,1)]
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

const startPos = Vector2i(4,1)
const nextPos = Vector2i(13,5)
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

var rng = RandomNumberGenerator.new()
#gamevars
signal scoreUpdate(p : int,l:int)
signal gameOver
var lines:int = 0
var points : int = 0
var highScore : Array = []
var highScoreNames : Array = []
var level = 0
var paused : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	newGame()
	
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
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
		emit_signal("scoreUpdate", points, level)
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
				get_parent().get_node("Board").set_cell(Vector2i(6-x,clears[3]), level, Vector2i(2,0))
				get_parent().get_node("Board").set_cell(Vector2i(5+x,clears[3]), level, Vector2i(2,0))
			if amount > 2: 
				get_parent().get_node("Board").set_cell(Vector2i(6-x,clears[2]), level, Vector2i(2,0))
				get_parent().get_node("Board").set_cell(Vector2i(5+x,clears[2]), level, Vector2i(2,0))
			if amount > 1: 
				get_parent().get_node("Board").set_cell(Vector2i(6-x,clears[1]), level, Vector2i(2,0))
				get_parent().get_node("Board").set_cell(Vector2i(5+x,clears[1]), level, Vector2i(2,0))
			if amount > 0: 
				get_parent().get_node("Board").set_cell(Vector2i(6-x,clears[0]), level, Vector2i(2,0))
				get_parent().get_node("Board").set_cell(Vector2i(5+x,clears[0]), level, Vector2i(2,0))
			await get_tree().create_timer(0.1).timeout
	
		for i in range (0,amount):
			for y in range(clears.max(),1,-1):
				if(blankRow(y-1) && y < clears.min()):
					continue
				if (y != clears.max()):
					for x in range(1,11):
						if(not empty(Vector2i(x,y-1))):
							get_parent().get_node("Board").set_cell(Vector2i(x,y),level,get_parent().get_node("Board").get_cell_atlas_coords(Vector2i(x,y-1)))
							get_parent().get_node("Board").set_cell(Vector2i(x,y-1),level,Vector2i(2,0))
				if (y == clears.max() && blankRow(clears.max())):
					for x in range(1,11):
						if(not empty(Vector2i(x,y-1))):
							get_parent().get_node("Board").set_cell(Vector2i(x,y),level,get_parent().get_node("Board").get_cell_atlas_coords(Vector2i(x,y-1)))
							get_parent().get_node("Board").set_cell(Vector2i(x,y-1),level,Vector2i(2,0))
		createPiece(piece)
		if(lines >= (10 + (level * 10))):
			levelUp()
		paused = false
func newGame():
	lines = 0
	points = 0
	level = 0
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
			get_parent().get_node("Board").set_cell(Vector2i(x,y),level,colors[alt])
			await get_tree().create_timer(0.005).timeout
		alt = (alt + 1) % 3
	for y in range(20,0,-1):
		for x in range(1,11):
			get_parent().get_node("Board").set_cell(Vector2i(x,y),level,Vector2i(2,0))
		await get_tree().create_timer(0.02).timeout
	emit_signal("gameOver")
	
func levelUp():
	level += 1
	moveTime[2] = dropTable[level]
func pick_piece():
	var p = randi() % 7
	return pieces.get(p)
	
func createPiece(p):
	rot = 0
	cur = startPos
	moveTicks = [0,0,0]
	draw(p[rot],startPos,pieceAtlases[pieces.find(piece)])
	draw(piece[0],nextPos,Vector2i(-1,-1))
	draw(next_piece[0],nextPos,pieceAtlases[pieces.find(next_piece)])
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
		cur = startPos
		if not paused:
			createPiece(piece)

func draw(p, coord, atlas):
	for i in p:
		set_cell(coord + i,level,atlas)
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
			get_parent().get_node("Board").set_cell(i+cur,level,pieceAtlases[pieces.find(piece)])
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
