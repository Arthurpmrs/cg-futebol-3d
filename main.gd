extends Node

class_name Main

var game_over_ui = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var game_over_scene = preload("res://game_over.tscn")
	game_over_ui = game_over_scene.instantiate()
	game_over_ui.visible = false
	print(game_over_ui)
	add_child(game_over_ui)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
