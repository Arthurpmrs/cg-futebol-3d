extends Control

func _ready():
	GameManager.player.connect("paused_game", Callable(self, "show_pause_menu"))
	$Modal/Continue.pressed.connect(_on_Continue_pressed)
	$Modal/HomeButton.pressed.connect(_on_HomeButton_pressed)

func show_pause_menu():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	self.visible = true
	get_tree().paused = true

func _on_Continue_pressed():
	get_tree().paused = false
	self.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_HomeButton_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://home_ui.tscn")


func _on_continue_mouse_entered() -> void:
	$HoverbtnSFX.play()
	
func _on_home_button_mouse_entered() -> void:
	$HoverbtnSFX.play()
