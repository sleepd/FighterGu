extends Node2D


func _on_Area2D_body_entered(body):
	$Tween.interpolate_property($Sprite, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.3)
	$Tween.start()
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	$Area2D/CollisionShape2D2.set_deferred("disabled", true)
