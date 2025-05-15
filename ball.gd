extends CharacterBody3D

@export var bola_radius := 0.3
@onready var _last_position = global_transform.origin

func _physics_process(_delta: float) -> void:
	var current_position = global_transform.origin
	var displacement = current_position - _last_position

	if displacement.length() > 0.001:
		var rotation_axis = displacement.normalized().cross(Vector3.UP).normalized()		
		if rotation_axis.length() > 0.001:
			rotation_axis = rotation_axis.normalized()
			var angular_distance = displacement.length() / bola_radius
			rotate(rotation_axis, angular_distance)

	_last_position = current_position
