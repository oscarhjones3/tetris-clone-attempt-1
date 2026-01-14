extends Sprite2D
var speed: int = 50
var rotSpeed: float = PI
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	var direction = 0
	if Input.is_action_pressed("ui_left"):
		direction = -1
	if Input.is_action_pressed("ui_right"):
		direction =1
	velocity = Vector2.UP.rotated(rotation) * speed
	rotation += rotSpeed * delta * direction
	position += velocity * delta
