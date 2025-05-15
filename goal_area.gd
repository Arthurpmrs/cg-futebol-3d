extends Area3D

@export var owner_team_name: String

func _on_body_entered(body: Node3D) -> void:
	if body.name == "Ball":
		GameManager.on_goal_scored(owner_team_name.to_lower())
