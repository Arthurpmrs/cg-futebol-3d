extends RigidBody3D

class_name Ball

enum BallState { FREE, ATTACHED, JUST_KICKED }

var state := BallState.FREE
var attached_to: Node3D = null
var offset := Vector3(0.0, 0.4, 1.2)
@export var bola_radius := 0.5
@onready var _head: Node3D = %Head
@onready var _last_position = _head.global_transform.origin
@onready var _attached_y_rotation = 0.0
@onready var initial_position: Vector3 = global_transform.origin

func _ready() -> void:
	GameManager.ball = self

func _physics_process(_delta: float) -> void:
	match state:
		BallState.ATTACHED:
			if attached_to:
				sleeping = true
				
				global_transform.basis = Basis.IDENTITY
				global_transform.origin = attached_to.global_transform.origin
				_head.transform.origin = offset.rotated(Vector3.UP, _attached_y_rotation)
	
				var current_position = _head.global_transform.origin
				var displacement = current_position - _last_position
				
				if displacement.length() > 0.001:
					var rotation_axis = displacement.normalized().cross(Vector3.UP).normalized()		
					if rotation_axis.length() > 0.001:
						rotation_axis = rotation_axis.normalized()
						var angular_distance = displacement.length() / bola_radius
						_head.rotate(rotation_axis, angular_distance)
			
				_last_position = current_position
		BallState.FREE:
			_head.transform.origin = Vector3.ZERO
			linear_velocity *= 0.98  # simples simulação de atrito

func set_attached_y_rotation(rotation_y: float) -> void:
	_attached_y_rotation = rotation_y

func kick_ball():
	if state == BallState.ATTACHED:
		state = BallState.FREE
		sleeping = false

		# Direção do chute
		var direction = attached_to._skin.global_transform.basis.z.normalized()

		# Força do chute
		var kick_strength = randf_range(20.0, 38.0)

		# Aplica velocidade
		linear_velocity = direction * kick_strength

		# Gira a bola para efeito visual (opcional)
		angular_velocity = Vector3.RIGHT * 5.0
		
		attached_to._ball_release_timer = 0.5
