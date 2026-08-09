extends Node

var lanternType = "dark"

@onready var fire_nodes = get_tree().get_nodes_in_group("Fire")

func _ready() -> void:
	lanternType = "dark"
	get_tree().get_first_node_in_group("transition").find_child("AnimationPlayer").play("transition_in")
	AudioManager.play_music(GameInfo.scenes.get(GameInfo.currLevel-1)["music"], false)
	setDarkenedLantern()
	for fire_node in fire_nodes:
		var area2d : Area2D = fire_node.find_child("Area2D")
		area2d.body_entered.connect(_on_fire_entered.bind(fire_node))

func setLightedLantern(color:="arcane"):
	# Sprite, disable dark blocks, enable light blocks, etc.
	var playerAnimSprite : AnimatedSprite2D = %Player.find_child("AnimatedSprite2D")
	playerAnimSprite.animation = "light_" + color
	playerAnimSprite.play()
	lanternType = "light_" + color
	disableDarkBlocks()
	enableLightBlocks(color)
	var glow : Sprite2D= %Player.find_child("Glow")
	var glow2 = %Player.find_child("Glow2")
	if color == "arcane":
		glow.modulate = Color("#89ffff59")
		glow2.modulate = Color("#89ffff59")
	elif color == "buzz":
		glow.modulate = Color("#eff08459")
		glow2.modulate = Color("#eff08459")
	elif color == "green":
		glow.modulate = Color("#b2ffbd59")
		glow2.modulate = Color("#b2ffbd59")
	elif color == "hotpink":
		glow.modulate = Color("#fe6b9259")
		glow2.modulate = Color("#fe6b9259")
	elif color == "purple":
		glow.modulate = Color("#e75fff59")
		glow2.modulate = Color("#e75fff59")
	glow.visible = true
	glow2.visible = true


func setDarkenedLantern():
	var playerAnimSprite : AnimatedSprite2D = %Player.find_child("AnimatedSprite2D")
	playerAnimSprite.animation = "dark"
	playerAnimSprite.play()
	lanternType = "dark"
	enableDarkBlocks()
	disableLightBlocks()
	%Player.find_child("Glow").visible = false
	%Player.find_child("Glow2").visible = false
	

func enableLightBlocks(color: String):
	%LightArcaneLayer.visible = false
	%LightArcaneLayer.collision_enabled = false
	%LightBuzzLayer.visible = false
	%LightBuzzLayer.collision_enabled = false
	%LightGreenLayer.visible = false
	%LightGreenLayer.collision_enabled = false
	%LightHotPinkLayer.visible = false
	%LightHotPinkLayer.collision_enabled = false
	%LightPurpleLayer.visible = false
	%LightPurpleLayer.collision_enabled = false
	if color == "arcane":
		%LightArcaneLayer.visible = true
		%LightArcaneLayer.collision_enabled = true
	elif color == "buzz":
		%LightBuzzLayer.visible = true
		%LightBuzzLayer.collision_enabled = true
	elif color == "green":
		%LightGreenLayer.visible = true
		%LightGreenLayer.collision_enabled = true
	elif color == "hotpink":
		%LightHotPinkLayer.visible = true
		%LightHotPinkLayer.collision_enabled = true
	elif color == "purple":
		%LightPurpleLayer.visible = true
		%LightPurpleLayer.collision_enabled = true
	var lightNodes := get_tree().get_nodes_in_group("isLight")
	var darkNodes := get_tree().get_nodes_in_group("isDark")
	for lightNode in lightNodes:
		if lightNode.get_meta("color", "e") == color or lightNode.get_meta("color", "e") == "all":
			lightNode.visible = true
			var cs : CollisionShape2D = lightNode.find_child("CollisionShape2D")
			if cs:
				cs.set_deferred("disabled", false)
		else:
			lightNode.visible = false
			var cs : CollisionShape2D = lightNode.find_child("CollisionShape2D")
			if cs:
				cs.set_deferred("disabled", true)
	
	for darkNode in darkNodes:
		darkNode.visible = false
		var cs : CollisionShape2D = darkNode.find_child("CollisionShape2D")
		cs.set_deferred("disabled", true)

func enableDarkBlocks():
	%DarkLayer.visible = true
	%DarkLayer.collision_enabled = true
	var lightNodes := get_tree().get_nodes_in_group("isLight")
	var darkNodes := get_tree().get_nodes_in_group("isDark")
	for lightNode in lightNodes:
		lightNode.visible = false
		var cs : CollisionShape2D = lightNode.find_child("CollisionShape2D")
		if cs:
			cs.set_deferred("disabled", true)
	for darkNode in darkNodes:
		darkNode.visible = true
		var cs : CollisionShape2D = darkNode.find_child("CollisionShape2D")
		if cs:
			cs.set_deferred("disabled", false)

func disableLightBlocks():
	%LightArcaneLayer.visible = false
	%LightArcaneLayer.collision_enabled = false
	%LightBuzzLayer.visible = false
	%LightBuzzLayer.collision_enabled = false
	%LightGreenLayer.visible = false
	%LightGreenLayer.collision_enabled = false
	%LightHotPinkLayer.visible = false
	%LightHotPinkLayer.collision_enabled = false
	%LightPurpleLayer.visible = false
	%LightPurpleLayer.collision_enabled = false
	

func disableDarkBlocks():
	%DarkLayer.visible = false
	%DarkLayer.collision_enabled = false

func resetLevel():
	GameInfo.change_scene(GameInfo.currLevel)

func _on_fan_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and not lanternType == "dark":
		AudioManager.play_sound("res://assets/audio/air_blow.mp3")
		setDarkenedLantern()

func _on_fire_entered(body: Node2D, fire_node: Node2D) -> void:
	if body.is_in_group("Player"):
		# what color fire is it
		print(fire_node.name)
		var color : String = fire_node.get_meta("color")
		if lanternType == "light_" + color:
			return
		AudioManager.play_sound("res://assets/audio/fire.mp3")
		setLightedLantern(color)


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
		var guh : Array[String]= ["\t-\tA notebook.", "\t-\tIts pages look yellow and tattered."]
		initiate_dialogues(guh, 2)
		%Notebook.queue_free()
		AudioManager.play_sound("res://assets/audio/item_get.wav")


func _on_huge_pig_enter(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var guh : Array[String] = ["\t-\tA huge pig.", "\t-\tFrom the tilt of the hog head, you swore that it was almost watching you.", "\t-\tIt holds implications beyond your understanding."]
		initiate_dialogues(guh, 2)
		%HugePig.queue_free()
		AudioManager.play_sound("res://assets/audio/item_get.wav")


func _on_telescreen_enter(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var guh : Array[String] = ["\t-\tA large television screen.", "\t-\t...", "\t-\tIs that a mic?"]
		initiate_dialogues(guh, 2)
		%Telescreen.queue_free()
		AudioManager.play_sound("res://assets/audio/item_get.wav")
