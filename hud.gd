extends TileMapLayer
var level = 0
var cAtlas = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for y in range(-2,22):
		for x in range(-15,23):
			cAtlas.append(get_cell_atlas_coords(Vector2i(x,y)))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_active_score_update(p: int, l: int, li:int) -> void:
	if(level != l):
		level = l
		for y in range(-2,22):
			for x in range(-15,23):
				var cell = (abs(-2-y) * 38) + abs(-15 - x)
				set_cell(Vector2i(x,y),l% 10,cAtlas[cell])
	get_child(0).set_text("Score \r" + str(p))
	get_child(1).set_text("Level \r" + str(l))
	get_child(2).set_text("Lines \r" + str(li))
	pass # Replace with function body.
