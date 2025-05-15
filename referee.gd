extends CharacterBody3D

enum State { MOVING_FORWARD, MOVING_BACK }
var state = State.MOVING_FORWARD

var speed = 6.0
@export var acceleration := 12.0

@onready var animation_player = $Skeleton_Mage/AnimationPlayer

func _physics_process(delta: float) -> void:
	var ball_z = GameManager.ball.position.z
	
	if velocity.z > 0.2:
		state = State.MOVING_FORWARD
	elif velocity.z < -0.2:
		state = State.MOVING_BACK
	
	var target_position = position
	target_position.z = ball_z
	var move_direction = (target_position - position).normalized()
	var distance_to_target = (target_position - position).length()
	if distance_to_target > 0.1:
		velocity = velocity.move_toward(move_direction * speed, acceleration * delta)
		move_and_slide()
	else:
		velocity = Vector3.ZERO
		
	if velocity.length() > 0.2:
		if state == State.MOVING_BACK:
			animation_player.play("Running_Strafe_Right")	
		elif state == State.MOVING_FORWARD:
			animation_player.play("Running_Strafe_Left")
	else:
		animation_player.play("Idle")		
