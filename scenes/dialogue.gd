extends Node

signal user_input_accept
var in_dialogue = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		handle_dialogue(self.find_child("DialogueText"), "\n\t-\tA notebook. What?")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		user_input_accept.emit()

func handle_dialogue(label: RichTextLabel, line: String, speed:=2.0):
	if in_dialogue:
		print("already in dialogue")
		return
	in_dialogue = true
	self.visible = true
	play_dialogue(label, line, speed)
	await user_input_accept
	await user_input_accept
	self.visible = false
	in_dialogue = false

func play_dialogue(label: RichTextLabel, line: String, speed := 2.0):
	label.text = ""
	var skipped = false
	var skip = func():
		label.text = line
		skipped = true
	user_input_accept.connect(skip)
	
	for i in line.length():
		# not always accurate
		if skipped:
			break
		label.text += line[i]
		AudioManager.play_sound("res://assets/audio/blip.wav")
		await get_tree().create_timer(0.1 / speed).timeout
	
	
