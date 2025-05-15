extends Node

signal score_updated(score_hero: int, score_skeleton: int)

var player: CharacterBody3D = null
@onready var enemies = []
var score_hero: int = 0
var score_skeleton: int = 0

func register_enemy(enemy: CharacterBody3D) -> void:
	enemies.append(enemy)

func on_goal_scored(goal: String):
	if goal == "hero":
		score_skeleton += 1
	else:
		score_hero += 1
	print("hero: ", score_hero, "  skeleton: ", score_skeleton)
	
	emit_signal("score_updated", score_hero, score_skeleton)
	
	reset_positions()

func reset_positions():
	player.global_transform.origin = player.get("initial_position")
	for enemy in enemies:
		enemy.global_transform.origin = enemy.get("initial_position")
