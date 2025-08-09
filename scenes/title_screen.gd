extends Control

@onready var new_game_menu: Control = $"New Game Menu"
@onready var seed_input: LineEdit = $"New Game Menu/Control/New Game Panel/Seed Input"

func _on_start_button_pressed() -> void:
	new_game_menu.visible = true

func _on_exit_button_pressed() -> void:
	get_tree().quit()

# New game menu
func _on_back_button_pressed() -> void:
	pass # Replace with function body.

func _on_next_button_pressed() -> void:
	if SignalBus.tutorial_shown == false:
		SignalBus.rng.seed = hash("TUTORIAL")
	elif seed_input.text != "" and SignalBus.tutorial_shown == true:
		SignalBus.rng.seed = hash(seed_input.text)
	else:
		SignalBus.rng.seed = hash(SignalBus.rng.randf())
	get_tree().change_scene_to_file("res://scenes/loading_scene.tscn")
