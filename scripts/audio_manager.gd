extends Node

var music_player : AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	music_player = AudioStreamPlayer.new()
	add_child(music_player)

func play_music(path: String, override:= false):
	var music_stream = load(path)
	if !override and (music_player.stream != null and music_player.stream.resource_name == music_stream.resource_name):
		return
	
	music_player.stream = music_stream
	music_player.play()

func stop_music():
	music_player.stop()

func play_sound(path: String):
	var sound_player = AudioStreamPlayer.new()
	add_child(sound_player)
	sound_player.stream = load(path)
	sound_player.play()
	await sound_player.finished
	sound_player.queue_free()
