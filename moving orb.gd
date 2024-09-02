extends AnimatableBody2D

var move_speed: float = 400


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float):
	# up
	var movement := Vector2(0.0, move_speed * delta * -1.0)
	# already synced right?
	self.position += movement


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
