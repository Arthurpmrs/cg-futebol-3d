extends Control

@onready var goal_label := $GoalLabel
@onready var countdown_label := $CountdownLabel

func _ready():
	GameManager.connect("goal_scored", Callable(self, "show_goal_announcement"))

func show_goal_announcement():
	self.visible = true
	goal_label.text = "GOOOOL!"
	countdown_label.text = ""
	
	await get_tree().create_timer(1.5, false).timeout

	goal_label.text = ""
	await show_countdown()
	
	self.visible = false
	GameManager.is_paused = false

func show_countdown():
	var messages = ["3...", "2...", "1...", "Crânios!"]
	for msg in messages:
		countdown_label.text = msg
		await get_tree().create_timer(0.7, false).timeout
	
