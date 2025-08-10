extends Control

@onready var message_label: Label = $Message

func _init():
	SignalBus.game_over.connect(game_over)

func game_over(message: String): 
	MusicHandler.wind_tape("lose")
	self.visible = true
	message_label.text = message

func restart(): 
	if SignalBus.has_set_custom_seed == false:
		SignalBus.rng.seed = hash(SignalBus.rng.randf() + Time.get_unix_time_from_system())
	SignalBus.rng.state = hash(SignalBus.rng.seed)
	MusicHandler.wind_tape("restart")
	get_tree().reload_current_scene()

func _on_quit_btn_pressed() -> void:
	SignalBus.load_scene("title")
