extends CharacterBody2D

@export var speed = 150
@export var jumpPower = 300
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("ui_right"):
		self.velocity.x = 1 * speed
	elif Input.is_action_pressed("ui_left"):
		self.velocity.x = -1 * speed
	else:
		self.velocity.x = 0
	
	if is_on_floor() and Input.is_action_pressed("ui_up"):
		self.velocity.y += -1 * jumpPower
	elif Input.is_action_pressed("ui_down"):
		# crush ground wip feature
		pass
	
	if not is_on_floor():
		self.velocity.y += gravity * delta
	
	
	
	self.move_and_slide()
	#print(self.position)
	
	
