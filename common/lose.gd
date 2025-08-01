extends Control

@onready var message_label: Label = $"LosePanel/Message"

func _init():
	SignalBus.game_over.connect(game_over)

func game_over(message: String): 
	self.visible = true
	message_label.text = message

func restart(): 
	get_tree().reload_current_scene()


