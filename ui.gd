extends Control

var total_seconds = 300  # 5 minutos

@onready var label = $CountdownText
@onready var timer = $CountdownTimer
var game_over_ui = null

@onready var hearts := [
	$LifeContainer/Heart1,
	$LifeContainer/Heart2,
	$LifeContainer/Heart3,
	$LifeContainer/Heart4,
	$LifeContainer/Heart5,
]

func _ready():
	update_label()
	timer.timeout.connect(_on_Timer_timeout)
	
	var game_over_scene = preload("res://game_over.tscn")
	game_over_ui = game_over_scene.instantiate()
	game_over_ui.visible = false
	add_child(game_over_ui)
	GameManager.player.connect("player_died", Callable(self, "show_game_over"))

func _on_Timer_timeout():
	if total_seconds > 0:
		if total_seconds <= 15:
			label.modulate = Color.RED
			piscar_texto()
		
		total_seconds -= 1
		update_label()
	else:
		timer.stop()
		show_game_over()

func update_label():
	var minutes = total_seconds / 60
	var seconds = total_seconds % 60
	label.text = "%02d:%02d" % [minutes, seconds]

func update_hearts(life: int):
	for i in range(hearts.size()):
		if i < life:
			hearts[i].texture = preload("res://addons/UI/heart_full.png")
		else:
			hearts[i].texture = preload("res://addons/UI/heart_empty.png")

func show_game_over():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	game_over_ui.visible = true
	get_tree().paused = true
	
func piscar_texto():
	var tween := create_tween()

	tween.tween_property(
		label, "scale", Vector2(1.4, 1.4), 0.15
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(
		label, "scale", Vector2(1.0, 1.0), 0.15
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
