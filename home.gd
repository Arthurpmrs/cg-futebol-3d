extends Control

var skull_icon := preload("res://addons/UI/skull_32x32.png")

func _ready():
	$ButtonsContainer/StartButton.pressed.connect(self._on_Start_pressed)
	$ButtonsContainer/ExitButton.pressed.connect(self._on_Exit_pressed)

	$ButtonsContainer/StartButton.mouse_entered.connect(self._on_Start_hovered)
	$ButtonsContainer/StartButton.mouse_exited.connect(self._on_Start_unhovered)
	$ButtonsContainer/ExitButton.mouse_entered.connect(self._on_Exit_hovered)
	$ButtonsContainer/ExitButton.mouse_exited.connect(self._on_Exit_unhovered)

func _on_Start_pressed():
	get_tree().change_scene_to_file("res://main.tscn")

func _on_Exit_pressed():
	get_tree().quit()

func _on_Start_hovered():
	$ButtonsContainer/StartButton.add_theme_icon_override("icon", skull_icon)

func _on_Start_unhovered():
	$ButtonsContainer/StartButton.remove_theme_icon_override("icon")
	
func _on_Exit_hovered():
	$ButtonsContainer/ExitButton.add_theme_icon_override("icon", skull_icon)

func _on_Exit_unhovered():
	$ButtonsContainer/ExitButton.remove_theme_icon_override("icon")

func _on_start_button_mouse_entered() -> void:
	$HoverbtnSFX.play()

func _on_exit_button_mouse_entered() -> void:
	$HoverbtnSFX.play()
