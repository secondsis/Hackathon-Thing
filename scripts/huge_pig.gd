extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameInfo.gotHugePig:
		self.visible = false
