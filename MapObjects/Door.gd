extends Area2D
class_name Door

func _physics_process(delta):
	if Input.is_action_just_pressed("interact"):
		var bodies = get_overlapping_bodies()
		if bodies.size() > 0:
			active(bodies)

func active(bodies):
	$AnimationPlayer.play("open")
