extends Node2D

var radius = 100
var rotation_speed = 2.0

var angle = 0.0

@onready var animBody = $AnimatableBody2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	angle += rotation_speed * delta
	animBody.position = Vector2(cos(angle), sin(angle)) * radius
