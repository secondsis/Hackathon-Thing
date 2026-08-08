extends Node

signal user_input_accept
signal dialogue_end
var in_dialogue = false
var startup

## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#
	#startup = func():
		##print("startup")
		#user_input_accept.disconnect(startup)
		#if not self.visible and not in_dialogue:
			#handle_dialogue(self.find_child("DialogueText"), "\n\t-\tA notebook. What?")
	#user_input_accept.connect(startup)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		#print("Emit user input")
		user_input_accept.emit()

func handle_dialogues(lines: Array[String], speed :=2.0):
	if in_dialogue:
		return
	in_dialogue = true
	self.visible = true
	for line in lines:
		play_dialogue(self.find_child("DialogueText"), line, speed)
		await dialogue_end
		#print("Waiting for user input before continuing...")
		await user_input_accept
		print("input")
	#print("Continuing... ending...")
	in_dialogue = false
	self.visible = false

func handle_dialogue(line: String, speed:=2.0):
	if in_dialogue:
		#print("already in dialogue")
		return
	in_dialogue = true
	self.visible = true
	play_dialogue(self.find_child("DialogueText"), line, speed)
	await dialogue_end
	#print("Waiting for user input before continuing...")
	await get_tree().process_frame
	await user_input_accept
	await get_tree().process_frame
	#print("Continuing... ending...")
	in_dialogue = false
	self.visible = false

var skip : Callable
var skipped = false
func play_dialogue(label: RichTextLabel, line: String, speed := 2.0):
	label.text = ""
	in_dialogue = true
	
	
	skip = func():
		print("Skipped line")
		user_input_accept.disconnect(skip)
		skipped = true
		label.text = line
	#user_input_accept.connect(skip)
	
	
	
	for i in line.length():
		# not always accurate
		if skipped:
			#print("skipped")
			skipped = false
			break
		label.text = line.substr(0, i+1)
		AudioManager.play_sound("res://assets/audio/blip.wav")
		if skipped:
			#print("skipped 2")
			skipped = false
			break
		await get_tree().create_timer(0.1 / speed).timeout
		
	in_dialogue = false
	dialogue_end.emit()
