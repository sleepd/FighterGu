extends Door
				
func active(bodies):
	if Global.has_key:
		$AnimationPlayer.play("open")
		Global.use_key()
