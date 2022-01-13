extends Door

export (String, "GoUp", "GoDown") var type = "GoUp"
export (NodePath) var targetNodePath

var targetGate: Node2D

func _ready():
	print(type)
	if type == "GoUp":
		$Sprite.frame = 12
	elif type == "GoDown":
		$Sprite.frame = 13
	else:
		print_debug("Err: PortalGate needs a type to show sprite")
		
	if targetNodePath == null:
		print_debug("Err: PortalGate needs a target portalGate!")
	else:
		targetGate = get_node(targetNodePath)
			
	
func active(bodies):
	bodies[0].portal(targetGate.position)

		

