extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = "Score: "
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_active_score_update(p: int,l:int, li:int) -> void:
	#text = "Score: \r" + str(p) # Replace with function body.
	pass
