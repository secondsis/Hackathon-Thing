extends Node2D


const scenes = [
	{
		"scene": "res://scenes/level_1.tscn",
		"music": "res://assets/audio/umbra.mp3"
	},
	{
		"scene": "res://scenes/level_2.tscn",
		"music": "res://assets/audio/umbra.mp3"
	},
	{
		"scene": "res://scenes/level_3.tscn",
		"music": "res://assets/audio/umbra.mp3"
	},
	{
		"scene": "res://scenes/level_4.tscn",
		"music": "res://assets/audio/umbra.mp3"
	},
	{
		"scene": "res://scenes/level_5.tscn",
		"music": "res://assets/audio/umbra.mp3"
	},
	{
		"scene": "res://scenes/level_6.tscn",
		"music": "res://assets/audio/umbra.mp3"
	},
	{
		"scene": "res://scenes/level_7.tscn",
		"music": "res://assets/audio/umbra.mp3"
	},
	{
		"scene": "res://scenes/level_8.tscn",
		"music": "res://assets/audio/umbra.mp3"
	},
	#{
		#"scene": "res://scenes/level_9.tscn",
		#"music": "res://assets/audio/umbra.mp3"
	#},
	#{
		#"scene": "res://scenes/level_10.tscn",
		#"music": "res://assets/audio/umbra.mp3"
	#}
]

var currLevel = 8
var lightDoorsComplete = 0
var darkDoorsComplete = 7
# Only possible if player has seen both other endings
var completionistDoorsComplete = 0
var gotNotebook = false
var gotTelescreen = false
var gotHugePig = false

# The player MUST complete the light ending and gather the three materials
# The three materials will allow the next run to spawn fans in replacement of the material
# This allows the player to open both doors. 
# The player may optionally do the dark ending without fans. 

# Light ending:
# Show a video recording of a screen with brainrot video
# Monologue will say smth like, "You saw the light. The light had no heart, 
# no soul. Its only purpose was to keep you entertained, and you were numbly satisfied."

# Dark ending: 
# Show headlines of articles. LGBTQ member killed, etc. banning books
# "You woke. You saw. You pained. You have a keen eye for things. Welcome to the truth."

# Complete ending: 
# Show nothing.
# "You watched the light descend. You watched as the world turned on itself, with everything 
# seemingly out of your control. Yet, you grasped onto hope. Perhaps there is no solution, and no 
# doubt if there was we wouldn't be here, but with this kind of resistence- this path...
# Maybe you'll change something. Or maybe you'll at least try. But you refused to be idle.  

func check_for_ending():
	if gotNotebook and gotTelescreen and gotHugePig:
		get_tree().change_scene_to_packed(load("res://scenes/true_ending.tscn"))
	elif lightDoorsComplete >= 7:
		get_tree().change_scene_to_packed(load("res://scenes/light_ending.tscn"))
	elif darkDoorsComplete >= 7:
		get_tree().change_scene_to_packed(load("res://scenes/woke_ending.tscn"))
	else:
		# Not a meaningful ending
		get_tree().change_scene_to_packed(load("res://scenes/indecisive_ending.tscn"))
	

func progress_scene():
	currLevel += 1
	change_scene(currLevel)
	
# level starting from index 1
func change_scene(level: int):
	var new_scene = func(p):
		if level-1 >= scenes.size():
			check_for_ending()
			return
		get_tree().change_scene_to_packed(load(scenes.get(level-1)["scene"]))
	print("Light: " + str(lightDoorsComplete))
	print("Dark: " + str(darkDoorsComplete))
	var transitionAnimPlayer : AnimationPlayer = get_tree().get_first_node_in_group("transition").find_child("AnimationPlayer")
	transitionAnimPlayer.play("transition_out")
	transitionAnimPlayer.animation_finished.connect(new_scene)
