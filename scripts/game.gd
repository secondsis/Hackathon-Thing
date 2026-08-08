extends Node


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
	
func enableDarkBlocks():
	%DarkLayer.visible = true

func disableLightBlocks():
	%LightLayer.visible = false

func disableDarkBlocks():
	%DarkLayer.visible = false


func _on_fan_entered(body: Node2D) -> void:
	setDarkenedLantern()

func _on_fire_entered(body: Node2D) -> void:
	setLightedLantern()
