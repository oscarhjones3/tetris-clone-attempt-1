extends Node
const PATH : String = "user://highScores.tres"
var level = 0
var player = 0
var records : Array
var recordNames : Array
var high : highScore
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	loadSave()
	records = high.highScores
	recordNames = high.names
	pass # Replace with function body.

func writeSave() -> void:
	high.highScores = records
	high.names = recordNames
	ResourceSaver.save(high, PATH)

func loadSave():
	if ResourceLoader.exists("user://highScores.tres"):
		high = ResourceLoader.load("user://highScores.tres")
	else:
		high = highScore.new()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
