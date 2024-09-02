extends Control

const moving_orb = preload("res://moving orb.tscn")
var score: int = 0:
	get:
		return score
	set(value):
		score = value
		if not is_node_ready():
			return
		$ScoreLabel.text = "Score:{n}".format({"n": value})
var unhit_bodies: Array[Node] = []
var time_score: int = 0:
	get:
		return time_score
	set(value):
		time_score = value
		if not is_node_ready():
			return
		$TimeLabel.text = "{n}".format({"n": value})
# Called when the node enters the scene tree for the first time.
#func _ready():
	#pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _physics_process(delta: float):
	

func _input(event : InputEvent):
	_create_orb_from_input(event)
	if event.is_action_pressed("game_reset"):
		# WARNING: When I add this game to Discrete Time's arcade, I need to change the reload method of this game.
		get_tree().reload_current_scene()

func _create_orb_from_input(event : InputEvent):
	var e: InputEventMouseButton = null
	if not (event is InputEventMouseButton):
		return
	e = event
	
	if (e.button_index == MouseButton.MOUSE_BUTTON_LEFT) and e.pressed:
		var spawn_pos := Vector2(e.position.x, self.size.y - 20)
		var obj := moving_orb.instantiate()
		obj.tree_exiting.connect(_on_moving_orb_despawn.bind(obj), 4)
		unhit_bodies.append(obj)
		$"2D".add_child(obj)
		obj.set_position(spawn_pos)

func _on_ball_body_exited(body: Node):
	if not(body in unhit_bodies):
		return
	unhit_bodies.erase(body)
	score += 1
	if $Timer.is_stopped():
		$Timer.start()

func _on_moving_orb_despawn(body: Node):
	if not(body in unhit_bodies):
		return
	unhit_bodies.erase(body)
	if score > 0 and $"2D/ball/VisibleOnScreenNotifier2D".is_on_screen():
		score -= 1

func _on_timer_timeout() -> void:
	time_score += 1

func _on_ball_exited() -> void:
	$Timer.stop()
