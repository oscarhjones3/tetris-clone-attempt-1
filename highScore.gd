class_name highScore
extends Resource

const PATH : String = "user://highScores.tres"

@export var highScores : Array
@export var names : Array

func _init() -> void:
	highScores = []
	names = []
	pass
		
