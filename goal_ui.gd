extends Control

@onready var goal_label = $GoalLabel
@onready var count_label = $CountLabel
@onready var timer = $Timer

func show_goal():
	visible = true
	goal_label.visible = true
	count_label.visible = false
	get_tree().paused = true
	
	await get_tree().create_timer(1).timeout
	goal_label.visible = false
	count_label.visible = true
	
	for i in range(3, 0, -1):
		count_label.text = str(i)
		await get_tree().create_timer(1).timeout
	
	visible = false
	get_tree().paused = false
	count_label.visible = false
