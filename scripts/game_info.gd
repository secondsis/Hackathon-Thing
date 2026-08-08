extends Node2D


const scenes = [
	{
		"scene": "res://scenes/level_1.tscn",
		"music": "res://assets/audio/umbra.mp3"
	},
	{
		"scene": "res://scenes/level_2.tscn",
		"music": "res://assets/audio/umbra.mp3"
	}
]

var currLevel = 1
var lightDoorsComplete = 0
var darkDoorsComplete = 0
# Only possible if player has seen both other endings
var completionistDoorsComplete = 0

func progress_scene():
	currLevel += 1
	change_scene(currLevel)
	
# level starting from index 1
func change_scene(level: int):
	var new_scene = func(p):
		get_tree().change_scene_to_packed(load(scenes.get(level-1)["scene"]))
	
	var transitionAnimPlayer : AnimationPlayer = %Transition.find_child("AnimationPlayer")
	transitionAnimPlayer.play("transition_out")
	transitionAnimPlayer.animation_finished.connect(new_scene)
