extends Area2D


# 碰到玩家
func _on_Key_body_entered(body):
	body.get_key() 
	$AnimationPlayer.play("pickup")
	Global.get_key()
