extends CharacterBody3D

@export var min_speed = 4.5
@export var max_speed = 6.5

@export var acceleration := 12.0
@export var rotation_speed := 3.0
var _gravity := -30

@onready var player: CharacterBody3D = GameManager.player
@onready var animation_player = $Pivot/Skeleton_Minion/AnimationPlayer
@onready var _skin: Node3D = %Skeleton_Minion
@onready var initial_position: Vector3 = global_transform.origin
var random_speed: float = randi_range(min_speed, max_speed)
var target_offset_x: float = randf_range(2.0, 6.0) * (1 if randf() > 0.5 else -1)
var target_offset_z: float = randf_range(2.0, 6.0) * (1 if randf() > 0.5 else -1)
var attack_target: Vector3 = Vector3.ZERO
var attack_speed: float = 0.0
var is_in_attack_mode: bool = false

func _ready() -> void:
	GameManager.register_enemy(self)

func get_target_position() -> Vector3:
	var player_velocity = player.velocity
	var distance_to_player = (player.position - position).length()
	var random_offset = Vector3(target_offset_x, 0, target_offset_z)
	var target_position = player.position 
	
	if distance_to_player > 12:
		target_position += player_velocity * 2.0
	else:
		target_position += random_offset
		if randf() < 0.005:
			target_offset_x = randf_range(2.0, 6.0) * (1 if randf() > 0.5 else -1)
			target_offset_z = randf_range(2.0, 6.0) * (1 if randf() > 0.5 else -1)
	
	return target_position

func _physics_process(delta: float) -> void:
	var target_position = get_target_position()
	
	var move_direction = (target_position - position).normalized()
	var y_velocity := velocity.y
	velocity.y = 0.0

	var distance_to_target = (target_position - position).length()
	if distance_to_target > 0.1:
		velocity = velocity.move_toward(move_direction * random_speed, acceleration * delta)
		velocity.y = y_velocity + _gravity * delta
		move_and_slide()
	else:
		velocity = Vector3.ZERO
	
	_skin.global_rotation.y = _get_skin_rotation_angle(target_position, delta)
	
	if velocity.length() > 0.2:
		animation_player.play("Running_A")
	else:
		animation_player.play("Idle")
	
func _get_skin_rotation_angle(target: Vector3, delta: float) -> float:
	var distance = (target - position).length()
	if distance <= 0.1:
		target = player.position
		
	var dir = (target - position).normalized()
	dir.y = 0.0
	
	if dir.length() < 0.01:
		return _skin.global_rotation.y 
	
	var target_basis = Basis.looking_at(dir, Vector3.UP)
	var target_angle = target_basis.get_euler().y + deg_to_rad(180)
	
	return lerp_angle(_skin.global_rotation.y, target_angle, rotation_speed * delta)
