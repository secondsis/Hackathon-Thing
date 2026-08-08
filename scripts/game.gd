extends Node

var lanternType = "dark"

func _ready() -> void:
	get_tree().get_first_node_in_group("transition").find_child("AnimationPlayer").play("transition_in")
	AudioManager.play_music(GameInfo.scenes.get(GameInfo.currLevel)["music"], false)
	setDarkenedLantern()

func setLightedLantern():
	# Sprite, disable dark blocks, enable light blocks, etc.
	var playerAnimSprite : AnimatedSprite2D = %Player.find_child("AnimatedSprite2D")
	playerAnimSprite.animation = "light"
	lanternType = "light"
	disableDarkBlocks()
	enableLightBlocks()
	%Player.find_child("Glow").visible = true
	%Player.find_child("Glow2").visible = true


func setDarkenedLantern():
	var playerAnimSprite : AnimatedSprite2D = %Player.find_child("AnimatedSprite2D")
	playerAnimSprite.animation = "dark"
	lanternType = "dark"
	enableDarkBlocks()
	disableLightBlocks()
	%Player.find_child("Glow").visible = false
	%Player.find_child("Glow2").visible = false
	

func enableLightBlocks():
	%LightLayer.visible = true
	%LightLayer.collision_enabled = true
	var lightNodes := get_tree().get_nodes_in_group("isLight")
	var darkNodes := get_tree().get_nodes_in_group("isDark")
	for lightNode in lightNodes:
		lightNode.visible = true
		var cs : CollisionShape2D = lightNode.find_child("CollisionShape2D")
		cs.disabled = false
	
	for darkNode in darkNodes:
		darkNode.visible = false
		var cs : CollisionShape2D = darkNode.find_child("CollisionShape2D")
		cs.disabled = true

func enableDarkBlocks():
	%DarkLayer.visible = true
	%DarkLayer.collision_enabled = true
	var lightNodes := get_tree().get_nodes_in_group("isLight")
	var darkNodes := get_tree().get_nodes_in_group("isDark")
	for lightNode in lightNodes:
		lightNode.visible = false
		var cs : CollisionShape2D = lightNode.find_child("CollisionShape2D")
		cs.disabled = true
	for darkNode in darkNodes:
		darkNode.visible = true
		var cs : CollisionShape2D = darkNode.find_child("CollisionShape2D")
		cs.disabled = false

func disableLightBlocks():
	%LightLayer.visible = false
	%LightLayer.collision_enabled = false

func disableDarkBlocks():
	%DarkLayer.visible = false
	%DarkLayer.collision_enabled = false

func resetLevel():
	GameInfo.change_scene(GameInfo.currLevel)

func _on_fan_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and not lanternType == "dark":
		AudioManager.play_sound("res://assets/audio/air_blow.mp3")
		setDarkenedLantern()

func _on_fire_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and not lanternType=="light":
		AudioManager.play_sound("res://assets/audio/fire.mp3")
		setLightedLantern()


func _on_void_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		AudioManager.play_sound("res://assets/audio/transition_effect.mp3")
		resetLevel()

func initiate_dialogue(line: String, speed := 2.0):
	%Dialogue.handle_dialogue(line, speed)

func initiate_dialogues(lines: Array[String], speed := 2.0):
	%Dialogue.handle_dialogues(lines, speed)

func _on_notebook_enter(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var guh : Array[String]= ["\n\t-\tA notebook.", "\n\t-\tIts pages look yellow and tattered."]
		initiate_dialogues(guh, 2)
		%Notebook.queue_free()
		AudioManager.play_sound("res://assets/audio/item_get.wav")


func _on_huge_pig_enter(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var guh : Array[String] = ["\n\t-\tA huge pig.", "\n\t-\tFrom the tilt of the hog head, you swore that it was almost watching you.", "\n\t-\tIt holds implications beyond your understanding."]
		initiate_dialogues(guh, 2)
		%HugePig.queue_free()
		AudioManager.play_sound("res://assets/audio/item_get.wav")


func _on_telescreen_enter(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var guh : Array[String] = ["\n\t-\tA large television screen.", "\n\t-\tIt looks larger than it needs to be."]
		initiate_dialogues(guh, 2)
		%Telescreen.queue_free()
		AudioManager.play_sound("res://assets/audio/item_get.wav")
