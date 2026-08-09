extends Node2D

@export var isLight = true

var didOtherDoor = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%LightDoor.find_child("Area2D").body_entered.connect(_on_area_2d_body_entered.bind(%LightDoor))
	%DarkDoor.find_child("Area2D").body_entered.connect(_on_area_2d_body_entered.bind(%DarkDoor))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func progress_level():
	GameInfo.currLevel += 1
	


func _on_area_2d_body_entered(body: Node2D, doorNode: Node2D) -> void:
	# Check if player
	if body.is_in_group("Player"):
		if doorNode.is_in_group("isLight"):
			GameInfo.lightDoorsComplete += 1
		elif doorNode.is_in_group("isDark"):
			AudioManager.play_sound("res://assets/audio/snd_ominous.wav")
			GameInfo.darkDoorsComplete += 1
		print("next scene")
		GameInfo.progress_scene()
