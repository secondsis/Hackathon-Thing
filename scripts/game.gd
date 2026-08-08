extends Node

func _ready() -> void:
	%Transition.find_child("AnimationPlayer").play("transition_in")
	AudioManager.play_music(GameInfo.scenes.get(GameInfo.currLevel)["music"], false)

func setLightedLantern():
	# Sprite, disable dark blocks, enable light blocks, etc.
	var playerAnimSprite : AnimatedSprite2D = %Player.find_child("AnimatedSprite2D")
	playerAnimSprite.animation = "light"
	disableDarkBlocks()
	enableLightBlocks()

func setDarkenedLantern():
	var playerAnimSprite : AnimatedSprite2D = %Player.find_child("AnimatedSprite2D")
	playerAnimSprite.animation = "dark"
	enableDarkBlocks()
	disableLightBlocks()
	

func enableLightBlocks():
	%LightLayer.visible = true
	%LightLayer.collision_enabled = true

func enableDarkBlocks():
	%DarkLayer.visible = true
	%DarkLayer.collision_enabled = true

func disableLightBlocks():
	%LightLayer.visible = false
	%LightLayer.collision_enabled = false

func disableDarkBlocks():
	%DarkLayer.visible = false
	%DarkLayer.collision_enabled = false

func resetLevel():
	GameInfo.change_scene(GameInfo.currLevel)

func _on_fan_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		setDarkenedLantern()

func _on_fire_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		setLightedLantern()


func _on_void_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		resetLevel()
