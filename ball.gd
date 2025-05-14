extends CharacterBody3D

@export var bola_radius := 0.3
var last_position: Vector3

@onready var _ball_pivot: Node3D = %BallPivot
@onready var _last_position = global_transform.origin

func _physics_process(delta: float) -> void:
	var current_position = global_transform.origin
	var displacement = current_position - _last_position

	if displacement.length() > 0.0:
		var rotation_axis = displacement.normalized().cross(Vector3.UP).normalized()
		var angular_distance = displacement.length() / bola_radius
		rotate(rotation_axis, angular_distance)

	_last_position = current_position
