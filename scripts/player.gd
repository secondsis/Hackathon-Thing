extends CharacterBody2D

@onready var Game = get_tree().current_scene.find_child("Game")

@export var speed = 150
@export var jumpPower = 300
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var is_moving = false
	if Input.is_action_pressed("ui_right"):
		is_moving = true
		self.velocity.x = 1 * speed
	elif Input.is_action_pressed("ui_left"):
		is_moving = true
		self.velocity.x = -1 * speed
	else:
		self.velocity.x = 0
	
	if is_on_floor():
		if Input.is_action_pressed("ui_up"):
			is_moving = true
			self.velocity.y += -1 * jumpPower
		
	#elif Input.is_action_pressed("ui_down"):
		## go crush smth in future
		#pass
	else:
		is_moving = true
		self.velocity.y += gravity * delta
	
	
	self.move_and_slide()
	var lanternType = Game.lanternType
	if is_moving:
		if $AnimatedSprite2D.animation != lanternType + "_walk":
			$AnimatedSprite2D.animation = lanternType + "_walk"
			$AnimatedSprite2D.play()
	else:
		if $AnimatedSprite2D.animation != lanternType:
			$AnimatedSprite2D.animation = lanternType
			$AnimatedSprite2D.play()
		
	#print(self.position)
	
	
