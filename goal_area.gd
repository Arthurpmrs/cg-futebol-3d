extends Area3D

@export var owner_team_name: String

@export var show_mesh: bool = false
@onready var mesh: MeshInstance3D = $MeshInstance3D

func _ready():
	if mesh:
		mesh.visible = show_mesh

func _on_body_entered(body: Node3D) -> void:
	if body.name == "Ball":
		GameManager.on_goal_scored(owner_team_name.to_lower())
