extends Control

@onready var message_label: Label = $Message

func _init():
	SignalBus.game_over.connect(game_over)

func game_over(message: String): 
	MusicHandler.wind_tape("lose")
	self.visible = true
	message_label.text = message

func restart(): 
	MusicHandler.wind_tape("restart")
	get_tree().reload_current_scene()
