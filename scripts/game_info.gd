extends Node2D


const scenes = [
	{
		"scene": "res://scenes/level_1.tscn",
		"music": "res://assets/audio/test.mp3"
	},
	{
		"scene": "res://scenes/level_2.tscn",
		"music": "res://assets/audio/test.mp3"
	}
]

var currLevel = 1

func progress_scene():
	currLevel += 1
	get_tree().change_scene_to_packed(load(scenes.get(currLevel-1)["scene"]))
	
