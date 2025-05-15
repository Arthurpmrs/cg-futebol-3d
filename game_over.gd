extends Control

func _ready():
	$Modal/PlayAgainButton.pressed.connect(_on_PlayAgainButton_pressed)
	$Modal/HomeButton.pressed.connect(_on_HomeButton_pressed)

func _on_PlayAgainButton_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_HomeButton_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://home_ui.tscn")
