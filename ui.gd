extends Control

var total_seconds = 300  # 5 minutos

@onready var clock_label = $CountdownText
@onready var timer = $CountdownTimer
@onready var _placar = %PlacarLabel
@onready var hearts := [
	$LifeContainer/Heart1,
	$LifeContainer/Heart2,
	$LifeContainer/Heart3,
	$LifeContainer/Heart4,
	$LifeContainer/Heart5,
]

signal finished_timer

func _ready():
	GameManager.ui = self
	update_clock_label()
	timer.timeout.connect(_on_Timer_timeout)
	GameManager.connect("score_updated", Callable(self, "_on_score_updated"))
	

func _on_score_updated(score_hero: int, score_skeleton: int) -> void:
	_placar.text = "%s x %s" % [score_hero, score_skeleton]

func _on_Timer_timeout():
	if total_seconds > 0:
		if total_seconds <= 15:
			clock_label.modulate = Color.RED
			piscar_texto()
		
		total_seconds -= 1
		update_clock_label()
	else:
		timer.stop()
		emit_signal("finished_timer", "TEMPO ESGOTADO!", "Agora é hora de contar os crânios... digo, os gols.")
		

func update_clock_label():
	var minutes = total_seconds / 60
	var seconds = total_seconds % 60
	clock_label.text = "%02d:%02d" % [minutes, seconds]

func update_hearts(life: int):
	for i in range(hearts.size()):
		if i < life:
			hearts[i].texture = preload("res://addons/UI/heart_full.png")
		else:
			hearts[i].texture = preload("res://addons/UI/heart_empty.png")
	
func piscar_texto():
	var tween := create_tween()

	tween.tween_property(
		clock_label, "scale", Vector2(1.4, 1.4), 0.15
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(
		clock_label, "scale", Vector2(1.0, 1.0), 0.15
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
