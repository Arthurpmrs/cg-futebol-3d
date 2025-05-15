extends CharacterBody3D

enum State { MOVING_LEFT, MOVING_RIGHT }
var state = State.MOVING_RIGHT

var left_limit = -3.0
var right_limit = 5.0
var speed = 4.0

@onready var animation_player = $Skeleton_Warrior/AnimationPlayer

func _physics_process(delta: float) -> void:
	match state:
		State.MOVING_LEFT:
			translate(Vector3.RIGHT * speed * delta)
			if global_position.x <= left_limit:
				state = State.MOVING_RIGHT
		State.MOVING_RIGHT:
			translate(Vector3.LEFT * speed * delta)
			if global_position.x >= right_limit:
				state = State.MOVING_LEFT
	
	if state == State.MOVING_LEFT:
		animation_player.play("Running_Strafe_Left")
	else:
		animation_player.play("Running_Strafe_Right")
