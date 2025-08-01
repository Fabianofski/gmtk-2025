extends Control 

@onready var label: Label = $"Label"

func _init():
	SignalBus.game_won.connect(func(x): show_text("Round %d" % (x + 1)))

func _ready():
	show_text("Round 1")

func show_text(msg: String): 
	label.text = msg 
	scale = Vector2.ZERO
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, 0.5) 
	tween.tween_property(self, "scale", Vector2.ZERO, 0.5) 

	
