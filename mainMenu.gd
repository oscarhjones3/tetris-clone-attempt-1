extends TileMapLayer
var menus = ["LevelSelect","PlayerSelect","StartButton"]
var level = 0
var player = 0
var menu = 0
var lBoardS : Array
var lBoardN : Array
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("LevelSelect/Level0").grab_focus()
	for i in range (0,10):
		get_node("LevelSelect/Level" + str(i)).toggle_mode = true
		if i < 4:
			get_node("PlayerSelect/Ctrl" + str(i)).toggle_mode = true
	lBoardS = GameStart.records
	lBoardN = GameStart.recordNames
	for i in range (0,lBoardS.size()):
		get_node("humanLeaderboard/Names/Name" + str(i)).text = lBoardN[i]
		get_node("humanLeaderboard/Scores/Score" + str(i)).text = str(lBoardS[i])
	for i in range (lBoardS.size(),10):
		get_node("humanLeaderboard/Names/Name" + str(i)).text = "---"
		get_node("humanLeaderboard/Scores/Score" + str(i)).text = "------"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("ui_accept")):
		menu = (menu + 1) % menus.size()
		get_node(menus[menu]).get_child(0).grab_focus()
		if(menu < 2):
			for i in get_node(menus[menu]).get_children():
				i.button_pressed = (false)
	if(Input.is_action_just_pressed("z")):
		menu = (menu + 2) % menus.size()
		get_node(menus[menu]).get_child(0).grab_focus()
		if(menu < 2):
			for i in get_node(menus[menu]).get_children():
				i.button_pressed = (false)
	pass





func _on_sb_pressed() -> void:
	if(Input.is_action_pressed("x")):
		GameStart.level = level + 10
	else:
		GameStart.level = level
	GameStart.player = player
	get_tree().change_scene_to_file("res://TetrisMain.tscn") # Replace with function body.


func _on_level_0_pressed() -> void:
	level = 0
func _on_level_1_pressed() -> void:
	level = 1
func _on_level_2_pressed() -> void:
	level = 2
func _on_level_3_pressed() -> void:
	level = 3
func _on_level_4_pressed() -> void:
	level = 4
func _on_level_5_pressed() -> void:
	level = 5
func _on_level_6_pressed() -> void:
	level = 6
func _on_level_7_pressed() -> void:
	level = 7
func _on_level_8_pressed() -> void:
	level = 8
func _on_level_9_pressed() -> void:
	level = 9


func _on_ctrl_0_pressed() -> void:
	player = 0 # Replace with function body.
func _on_ctrl_1_pressed() -> void:
	player = 1
func _on_ctrl_2_pressed() -> void:
	player = 2
func _on_ctrl_3_pressed() -> void:
	player = 3
