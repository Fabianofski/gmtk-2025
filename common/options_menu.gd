extends Control

@onready var credits: Label = $"Control/Options Panel/Credits"
@onready var tutorial_checkbox: CheckBox = $"Control/Options Panel/Tutorial Checkbox"
@onready var music_volume_slider: HSlider = $"Control/Options Panel/Music Volume Slider"
@onready var sfx_volume_slider: HSlider = $"Control/Options Panel/SFX Volume Slider"

func _ready() -> void: # Prepare the options menu
	credits.text = "Pętla v"+ProjectSettings.get_setting("application/config/version")+", by F4B1 (code), Santum (art) and nanumerino (music)"
	MusicHandler.adjust_sound()
	music_volume_slider.value = MusicHandler.music_volume
	sfx_volume_slider.value = MusicHandler.sfx_volume
	tutorial_checkbox.button_pressed = not SignalBus.tutorial_shown

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("options_menu"):
		self.visible = not self.visible

func _on_music_volume_slider_value_changed(value: float) -> void:
	MusicHandler.music_volume = value
	MusicHandler.adjust_sound()

func _on_sfx_volume_slider_value_changed(value: float) -> void:
	MusicHandler.sfx_volume = value
	MusicHandler.adjust_sound()

func _on_tutorial_checkbox_pressed() -> void:
	SignalBus.tutorial_shown = not tutorial_checkbox.button_pressed

func _on_back_button_pressed() -> void:
	self.visible = false
