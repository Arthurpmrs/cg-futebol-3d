extends CharacterBody3D

@export_group("Camera")
@export_range(0.0, 1.0) var mouse_sensitivity := 0.25

@export_group("Movement")
@export var move_speed := 8.0
@export var acceleration := 20.0
@export var rotation_speed := 12.0
@export var jump_impulse := 12.0

var _camera_input_direction := Vector2.ZERO
var _last_movement_direction := Vector3.BACK
var _gravity := -30

@onready var _camera_pivot: Node3D = %CameraPivot
@onready var _camera: Camera3D = %Camera3D
@onready var _skin: Node3D = %Knight
@onready var _ball: RigidBody3D = %Ball
@onready var animation_player = $Pivot/Knight/AnimationPlayer
@onready var initial_position: Vector3 = global_transform.origin
@onready var _ball_release_timer = 0.0

var max_life := 5
var current_life := max_life
var _invincible_timer := 0.0

signal life_changed(new_life)

signal player_died(gameover_title, gameover_text)

func _ready() -> void:
	GameManager.player = self
	var hud = get_tree().get_root().get_node("Main/UI")  # ajuste o caminho conforme sua cena
	self.connect("life_changed", Callable(hud, "update_hearts"))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _unhandled_input(event: InputEvent) -> void:
	var is_camera_motion := (
		event is InputEventMouseMotion and
		Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	)
	if is_camera_motion:
		_camera_input_direction = event.screen_relative * mouse_sensitivity
	
	if event.is_action_pressed("kick"):
		if _ball.state == Ball.BallState.ATTACHED:
			_ball.kick_ball()
	
func _physics_process(delta: float) -> void:
	_camera_pivot.rotation.x += _camera_input_direction.y * delta
	_camera_pivot.rotation.x = clamp(_camera_pivot.rotation.x, -PI / 6.0 , PI / 3.0)
	_camera_pivot.rotation.y -= _camera_input_direction.x * delta
	
	_camera_input_direction = Vector2.ZERO
	
	var raw_input := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var forward := _camera.global_basis.z
	var right := _camera.global_basis.x
	
	var move_direction := forward * raw_input.y + right * raw_input.x
	move_direction.y = 0.0
	move_direction = move_direction.normalized()
	
	var y_velocity := velocity.y
	velocity.y = 0.0
	velocity = velocity.move_toward(move_direction * move_speed, acceleration * delta)
	velocity.y = y_velocity + _gravity * delta
	
	var is_starting_jump := Input.is_action_just_pressed("jump") and is_on_floor()
	if is_starting_jump:
		velocity.y += jump_impulse
	move_and_slide()
	
	if move_direction.length() > 0.2:
		_last_movement_direction = move_direction
	var target_angle := Vector3.BACK.signed_angle_to(_last_movement_direction, Vector3.UP)
	_skin.global_rotation.y = lerp_angle(_skin.rotation.y, target_angle, rotation_speed * delta)
	
	if _ball_release_timer > 0.0:
		_ball_release_timer -= delta
		
	#_ball_pivot.rotation.y = _skin.global_rotation.y
	if _ball.state == Ball.BallState.ATTACHED:
		_ball.set_attached_y_rotation(_skin.global_rotation.y)

	var dist = global_transform.origin.distance_to(_ball.global_transform.origin)
	if dist < 2.0 and _ball.state == Ball.BallState.FREE and _ball_release_timer <= 0.0:
		_ball.state = Ball.BallState.ATTACHED
		_ball.attached_to = self
		
	var ground_speed := velocity.length()
	if is_starting_jump:
		animation_player.play("Jump_Start")
	elif not is_on_floor() and velocity.y < 0:
		animation_player.play("Jump_Idle")
	elif is_on_floor():
		if ground_speed > 0.0:
			animation_player.play("Running_A")
		else:
			animation_player.play("Idle")
	
	# Checa a colisão com o esqueleto
	if _invincible_timer > 0.0:
		_invincible_timer -= delta
		if _invincible_timer < 0.05:
			set_opacity_recursive(_skin, 1.0)	
	else:
		for index in range(get_slide_collision_count()):
			var collision = get_slide_collision(index)
			if collision.get_collider() == null:
				continue

			if collision.get_collider().is_in_group("skeleton"):
				take_damage()
				break

func take_damage(amount = 1):
	current_life = max(current_life - amount, 0)
	emit_signal("life_changed", int(current_life))
	_invincible_timer = 1.5
	set_opacity_recursive(_skin, 0.6)
	if current_life == 0:
		die()

func die():
	emit_signal("player_died", "VOCÊ MORREU!", "Talvez usar a cabeça (em vez de chutar uma) fosse melhor.")

func set_mesh_opacity(mesh_instance: MeshInstance3D, opacity: float) -> void:
	if mesh_instance.mesh == null:
		return

	opacity = clamp(opacity, 0.0, 1.0)
	var surface_count = mesh_instance.mesh.get_surface_count()

	for i in surface_count:
		var material = mesh_instance.get_active_material(i)
		if material and material is StandardMaterial3D:
			if opacity < 1.0:
				material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
			else:
				material.transparency = BaseMaterial3D.TRANSPARENCY_DISABLED

			var color = material.albedo_color
			color.a = opacity
			material.albedo_color = color
			
func set_opacity_recursive(node: Node, opacity: float) -> void:
	for child in node.get_children():
		if child is MeshInstance3D:
			set_mesh_opacity(child, opacity)
		set_opacity_recursive(child, opacity)
	
	
