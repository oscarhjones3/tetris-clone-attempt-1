extends TileMapLayer
var L0 = [Vector2i(0,0),Vector2i(0,1),Vector2i(1,0),Vector2i(2,0)]

var J0 = [Vector2i(0,0),Vector2i(2,1),Vector2i(1,0),Vector2i(2,0)]

var S0 = [Vector2i(0,1),Vector2i(1,0),Vector2i(1,1),Vector2i(2,0)]

var Z0 = [Vector2i(0,0),Vector2i(1,0),Vector2i(1,1),Vector2i(2,1)]

var O0 = [Vector2i(0,0),Vector2i(1,0),Vector2i(0,1),Vector2i(1,1)]

var falls = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(0,4):
		set_cell(Vector2i(O0[i].x + 5,O0[i].y), 1, Vector2i(1,0))
	
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	var prev = []
	for i in range(0,4):
		prev.append(Vector2i(O0[i].x+5,O0[i].y+falls))
	falls += 1
	for i in range(0,4):
		set_cell(prev[i],-1)
	for i in range (0,4):
		set_cell(Vector2i(O0[i].x+5,O0[i].y+falls),1, Vector2i(1,0))
