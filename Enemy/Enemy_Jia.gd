extends KinematicBody2D

var velocity = Vector2(0, 0)
var speed: int = 40
var direction = -1
var hp = 2
var gravity = 20
var get_money_efx
export var move: bool = true
export var hurt: bool = false
onready var state_machine: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/playback")

func _ready():
	state_machine = $AnimationTree.get("parameters/playback")
	get_money_efx = preload("res://money_float_up .tscn")

func _physics_process(delta):
	if $PlayerChecker.is_colliding() and not hurt:
		move = false
		state_machine.travel("attack")
	elif is_on_wall() or not $floorChecker.is_colliding() and is_on_floor():
		flip()

	velocity.y += gravity
	velocity.x = speed * direction
	if move and not hurt:
		velocity = move_and_slide(velocity, Vector2.UP)

func flip():
	scale.x *= -1
	direction *= -1




func hurt():
	hp -= 1
	$AudioStreamPlayer2D.play(0.26)
	state_machine.travel("hurt")
	hurt = true
	if hp <= 0:
		die()
		
func die():
	$PlayerChecker.enabled = false
	state_machine.travel("die")
	gravity = 0
	$CollisionShape2D.set_deferred("disabled", true)
	speed = 0
	var efx = get_money_efx.instance()
	get_parent().add_child(efx)
	efx.global_position = global_position
	Global.add_money(100)


func _on_AtkArea_body_entered(body):
	body.hurt()
