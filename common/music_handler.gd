extends Node

@onready var music_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	music_player.play()

func wind_tape(sitch):
	match sitch:
		"restart":
			music_player.pitch_scale = 0.25
			var tween = get_tree().create_tween()
			tween = get_tree().create_tween()
			tween.set_ease(Tween.EASE_OUT)
			tween.tween_property(music_player, "pitch_scale", 1.0, 2)
		"lose":
			music_player.pitch_scale = 1.0
			var tween = get_tree().create_tween()
			tween = get_tree().create_tween()
			tween.set_ease(Tween.EASE_IN)
			tween.tween_property(music_player, "pitch_scale", 0.25, 1)
