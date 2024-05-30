extends Node2D

var player

onready var anim:AnimationPlayer = get_node("AnimationPlayer")
onready var active_area = get_node("Area2D/ActiveArea")



func _physics_process(delta):
	if Input.is_action_just_pressed("interact") and not anim.is_playing():
		var bodies = active_area.get_overlapping_bodies()
		if bodies.size() > 0:
			player = bodies[0]
			lock_player()
			if $Path2D/PathFollow2D.unit_offset == 0:
				print("elevator going up")
				anim.play("up")
			else:
				print("elevator going down")
				anim.play_backwards("up")
		else:
			player = null
			
func lock_player():
	player.lock()
	
func unlock_player():
	player.unlock()


func _on_AnimationPlayer_animation_finished(anim_name):
	unlock_player()
