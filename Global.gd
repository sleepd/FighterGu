extends Node

var money:int = 0
var has_key:bool = false
signal money_update
signal get_key
signal key_used

func add_money(new_money):
	money += new_money
	emit_signal("money_update")
	
func get_key():
	has_key = true
	emit_signal("get_key")
	
func use_key():
	has_key = false
	emit_signal("key_used")
	
func quit():
	get_tree().quit()
