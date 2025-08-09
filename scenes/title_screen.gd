extends Control

@onready var new_game_menu: Control = $"New Game Menu"
@onready var seed_input: LineEdit = $"New Game Menu/Control/New Game Panel/Seed Input"

@onready var next_button: Button = $"New Game Menu/Control/New Game Panel/Next Button"

@onready var options_menu: Control = $"Options Menu"
@onready var credits: Label = $"Options Menu/Control/Options Panel/Credits"
@onready var tutorial_checkbox: CheckBox = $"Options Menu/Control/Options Panel/Tutorial Checkbox"
@onready var music_volume_slider: HSlider = $"Options Menu/Control/Options Panel/Music Volume Slider"
@onready var sfx_volume_slider: HSlider = $"Options Menu/Control/Options Panel/SFX Volume Slider"

func _ready() -> void: # Prepare the options menu
	credits.text = "Pętla v"+ProjectSettings.get_setting("application/config/version")+", by F4B1 (code), Santum (art) and nanumerino (music)"
	MusicHandler.adjust_sound()
	music_volume_slider.value = MusicHandler.music_volume
	sfx_volume_slider.value = MusicHandler.sfx_volume
	tutorial_checkbox.button_pressed = not SignalBus.tutorial_shown

func _on_start_button_pressed() -> void:
	next_button.disabled = false
	new_game_menu.visible = true

func _on_options_pressed() -> void:
	music_volume_slider.editable = true
	sfx_volume_slider.editable = true
	tutorial_checkbox.disabled = false
	options_menu.visible = true

func _on_exit_button_pressed() -> void:
	get_tree().quit()

# New game menu
func _on_back_button_pressed() -> void:
	next_button.disabled = true
	new_game_menu.visible = false
	music_volume_slider.editable = false
	sfx_volume_slider.editable = false
	tutorial_checkbox.disabled = true
	options_menu.visible = false

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

# Options menu
func _on_music_volume_slider_value_changed(value: float) -> void:
	MusicHandler.music_volume = value
	MusicHandler.adjust_sound()

func _on_sfx_volume_slider_value_changed(value: float) -> void:
	MusicHandler.sfx_volume = value
	MusicHandler.adjust_sound()

func _on_tutorial_checkbox_pressed() -> void:
	SignalBus.tutorial_shown = not tutorial_checkbox.button_pressed
	print(SignalBus.tutorial_shown)
