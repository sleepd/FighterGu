extends Area2D

func next_level():
	get_tree().change_scene("res://Levels/Level2.tscn")


func _on_GoalPoint_body_entered(body):
	$GoalAnimationPlayer.play("nextLevel")
