extends Control

@onready var credits: Label = $"Control/Options Panel/Credits"
@onready var tutorial_checkbox: CheckBox = $"Control/Options Panel/Tutorial Checkbox"
@onready var music_volume_slider: HSlider = $"Control/Options Panel/Music Volume Slider"
@onready var sfx_volume_slider: HSlider = $"Control/Options Panel/SFX Volume Slider"

func _ready() -> void: # Prepare the options menu
	credits.text = "Pętla v"+ProjectSettings.get_setting("application/config/version")+", by F4B1 (code), Santum (art) and nanumerino (music)"
	var saved_settings = SaveFile.load_from_file("options")
	music_volume_slider.value = saved_settings.music_volume
	sfx_volume_slider.value = saved_settings.sfx_volume
	tutorial_checkbox.button_pressed = not saved_settings.has_seen_tutorial
	apply_saved_settings()
	MusicHandler.adjust_sound()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("options_menu"):
		self.visible = not self.visible

func apply_saved_settings():
	_on_music_volume_slider_value_changed(music_volume_slider.value)
	_on_sfx_volume_slider_value_changed(sfx_volume_slider.value)
	_on_tutorial_checkbox_pressed()

func _on_music_volume_slider_value_changed(value: float) -> void:
	MusicHandler.music_volume = value
	MusicHandler.adjust_sound()
	SaveFile.save_to_file("options", "music_volume", MusicHandler.music_volume)

func _on_sfx_volume_slider_value_changed(value: float) -> void:
	MusicHandler.sfx_volume = value
	MusicHandler.adjust_sound()
	SaveFile.save_to_file("options", "sfx_volume", MusicHandler.sfx_volume)

func _on_tutorial_checkbox_pressed() -> void:
	SignalBus.tutorial_shown = not tutorial_checkbox.button_pressed
	SaveFile.save_to_file("options", "has_seen_tutorial", SignalBus.tutorial_shown)

func _on_back_button_pressed() -> void:
	self.visible = false
