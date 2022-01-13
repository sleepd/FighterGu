extends KinematicBody2D

export var speed = 200
export var climb_speed = 200
export var jump_force = 600
export var gravity = 30
export var is_controlable = true
export var atk_sta = 1
export var knockback_force = 0


var jump = false
var velocity = Vector2(0, 0)
var directrion = 1
var idle: bool = true
var on_ladder: bool = false
var climbing: bool = false
var state_machine: AnimationNodeStateMachinePlayback
var jumpSound = preload("res://SFX/Jump.wav")
var key_number = 0
onready var Efxplayer = get_node("Sprite/EfxAnimationPlayer")

func _ready():
	is_controlable = true
	state_machine = $AnimationTree.get("parameters/playback")
	knockback_force = 0

func _physics_process(delta):
	velocity.x = 0
	_check_input()
	velocity.x += -knockback_force * directrion

	if not is_on_floor() and not climbing and is_controlable:
		#is_controlable = true
		state_machine.travel("Jump")
	
	if climbing and is_on_floor() and not $PlatformChecker.is_colliding():
		exit_climbing()
		
	
	velocity.y += gravity
	var snap = Vector2.ZERO if jump else Vector2.DOWN * 32
	
	velocity = move_and_slide_with_snap(velocity, snap, Vector2.UP)
	
	# E键提示
	
	var areas = $E_KEY/HelpChecker.get_overlapping_areas()
	if areas.size() > 0:
		for area in areas:
			if area.name != "LockedDoor":
				$E_KEY.visible = true
			elif area.name == "LockedDoor" and Global.has_key:
				$E_KEY.visible = true
	else:
		$E_KEY.visible = false

func _check_input():
	if is_controlable:
		if Input.is_action_pressed("right"):
			velocity.x = speed
			if climbing:
				state_machine.travel("Climb")
			else:
				state_machine.travel("Walk")
				if directrion == -1:
					flip()
		elif Input.is_action_pressed("left"):
			velocity.x = -speed
			if climbing:
				state_machine.travel("Climb")
			else:
				state_machine.travel("Walk")
				if directrion == 1:
					flip()
		elif idle:
			if climbing:
				state_machine.travel("Climb_idle")
			else:
				state_machine.travel("Idle")
		
		# 攻击	
		if Input.is_action_just_pressed("attack") and is_on_floor():
			if $AtkTimer.is_stopped():
				atk_sta = 1
			state_machine.travel("Atk0"+String(atk_sta))
			$AtkTimer.start()
			is_controlable = false
			atk_sta += 1
			# 打完第三招后变回第一招
			if atk_sta >=4:
				atk_sta = 1
					
		# 跳跃
		if Input.is_action_just_pressed("jump") and is_on_floor(): 
			velocity.y -= jump_force
			$AudioStreamPlayer2D.stream = jumpSound
			$AudioStreamPlayer2D.play()
			jump = true
			
		# 爬楼梯
		if on_ladder:
			if Input.is_action_pressed("up"):
				# 判断是否已经站在梯子顶端
				if $PlatformChecker_up.is_colliding() or climbing:
					gravity = 0
					velocity.y = -climb_speed
					climbing = true
					state_machine.travel("Climb")
					collision_one_way(false)
			elif Input.is_action_pressed("down"):
				# 判断下方是地板的情况
				if not is_on_floor() or $PlatformChecker.is_colliding():
					gravity = 0
					velocity.y = climb_speed
					climbing = true
					state_machine.travel("Climb")
					collision_one_way(false)
			elif climbing:
				velocity.y = 0
		elif climbing:
			exit_climbing()


func flip():
	scale.x *= -1
	directrion *= -1
	$E_KEY.scale.x *= -1
	
func collision_one_way(state:bool):
	set_collision_mask_bit(5, state)
	
func exit_climbing():
	gravity = 30
	climbing = false
	collision_one_way(true)


func hurt():
	print("Player hurt!")
	$Sprite/EfxAnimationPlayer.play("Hurt")
	velocity.x += -100 * directrion

func portal(target_position:Vector2):
	is_controlable = false
	Efxplayer.play("FadeIn")
	yield($Sprite/EfxAnimationPlayer, "animation_finished")
	position = target_position
	Efxplayer.play("FadeOut")
	yield(Efxplayer, "animation_finished")
	is_controlable = true

func lock():
	is_controlable = false
	
func unlock():
	is_controlable = true

func _on_Area2D_body_entered(body):
	body.hurt()
		
func get_key():
	key_number += 1


func _on_LadderChecker_area_entered(area):
	on_ladder = true


func _on_LadderChecker_area_exited(area):
	on_ladder = false
