extends Node2D

@export var isLight = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func progress_level():
	GameInfo.currLevel += 1
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	# Check if player
	if body.is_in_group("Player"):
		GameInfo.progress_scene()
