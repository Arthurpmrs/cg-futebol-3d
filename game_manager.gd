extends Node

signal score_updated(score_hero: int, score_skeleton: int)
signal goal_scored

var player: CharacterBody3D = null
var ball: RigidBody3D = null
var ui: Control = null
@onready var enemies = []
var score_hero: int = 0
var score_skeleton: int = 0
var is_paused: bool = false

func _process(_delta: float) -> void:
	if ball == null or player == null:
		return
	if ball.position.y < -25.0 or player.position.y < -25.0:
		reset_positions()

func register_enemy(enemy: CharacterBody3D) -> void:
	enemies.append(enemy)

func on_goal_scored(goal: String):
	if goal == "hero":
		score_skeleton += 1
	else:
		score_hero += 1
	print("hero: ", score_hero, "  skeleton: ", score_skeleton)
	
	emit_signal("score_updated", score_hero, score_skeleton)
	is_paused = true
	emit_signal("goal_scored")
	reset_positions()
	

func reset_positions():
	player.reset_hero()
	ball.global_transform.origin = ball.get("initial_position")
	ball.linear_velocity = Vector3.ZERO
	for enemy in enemies:
		if enemy:
			enemy.reset_enemy()
		
