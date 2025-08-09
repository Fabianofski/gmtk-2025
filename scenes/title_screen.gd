extends Control

@onready var new_game_menu: Control = $"New Game Menu"
@onready var seed_input: LineEdit = $"New Game Menu/Control/New Game Panel/Seed Input"

@onready var next_button: Button = $"New Game Menu/Control/New Game Panel/Next Button"

func _on_start_button_pressed() -> void:
	next_button.disabled = false
	new_game_menu.visible = true

func _on_exit_button_pressed() -> void:
	get_tree().quit()

# New game menu
func _on_back_button_pressed() -> void:
	next_button.disabled = true
	new_game_menu.visible = false

func _on_next_button_pressed() -> void:
	if SignalBus.tutorial_shown == false:
		SignalBus.has_set_custom_seed = true
		SignalBus.rng.seed = hash("TUTORIAL")
	elif seed_input.text != "" and SignalBus.tutorial_shown == true:
		SignalBus.has_set_custom_seed = true
		SignalBus.rng.seed = hash(seed_input.text)
	else:
		SignalBus.has_set_custom_seed = false
		SignalBus.rng.seed = hash(SignalBus.rng.randf())
	SignalBus.rng.state = hash(SignalBus.rng.seed)
	SignalBus.load_scene("game")
