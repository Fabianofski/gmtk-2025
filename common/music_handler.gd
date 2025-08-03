extends Node

@onready var game_music: AudioStreamPlayer = $"Game Music"
@onready var main_menu_music: AudioStreamPlayer = $"Main Menu"

func _ready() -> void:
	main_menu_music.play()

func switch_to_game_music():
	game_music.volume_db = -8.0
	main_menu_music.stop()

func wind_tape(sitch):
	match sitch:
		"restart":
			game_music.pitch_scale = 0.25
			var tween = get_tree().create_tween()
			tween = get_tree().create_tween()
			tween.set_ease(Tween.EASE_OUT)
			tween.tween_property(game_music, "pitch_scale", 1.0, 2)
		"lose":
			game_music.pitch_scale = 1.0
			var tween = get_tree().create_tween()
			tween = get_tree().create_tween()
			tween.set_ease(Tween.EASE_IN)
			tween.tween_property(game_music, "pitch_scale", 0.25, 2)
		"next_round":
			game_music.pitch_scale = randf_range(0.25, 1.5)
			var tween = get_tree().create_tween()
			tween = get_tree().create_tween()
			tween.set_ease(Tween.EASE_OUT)
			tween.tween_property(game_music, "pitch_scale", 1.0, 0.25)
