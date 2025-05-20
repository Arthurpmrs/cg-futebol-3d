extends Control

@onready var title_label = $Modal/TitleLabel
@onready var message_label = $Modal/TextLabel

func _ready():
	GameManager.ui.connect("finished_timer", Callable(self, "show_game_over"))
	GameManager.player.connect("player_died", Callable(self, "show_game_over"))
	$Modal/PlayAgainButton.pressed.connect(_on_PlayAgainButton_pressed)
	$Modal/HomeButton.pressed.connect(_on_HomeButton_pressed)

func show_game_over(title: String, message: String):
	print('bbb')
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	self.visible = true
	title_label.text = title
	message_label.text = message
	get_tree().paused = true

func _on_PlayAgainButton_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_HomeButton_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://home_ui.tscn")
