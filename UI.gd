extends CanvasLayer

onready var money_label = $UI/Money

func _ready():
	Global.connect("money_update", self, "_on_money_changed")
	Global.connect("get_key", self, "_on_get_key")
	Global.connect("key_used", self, "_on_key_used")
	money_label.text = str(Global.money)
	$UI/Key.visible = false
	
func _on_money_changed():
	money_label.text = str(Global.money)
	
func _on_get_key():
	$UI/Key.visible = true
	
func _on_key_used():
	$UI/Key.visible = false
	

