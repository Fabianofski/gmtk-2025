extends Node3D

@onready var decoration: Node3D = $Decoration

func _ready() -> void:
	SignalBus.next_round_started.connect(_switch_sides)

func _switch_sides(state):
	var tween := create_tween()
	match state:
		Game.STATE.Attack:
			tween.tween_property(decoration, "rotation_degrees:y", 0, 0.5)
		Game.STATE.Defense:
			tween.tween_property(decoration, "rotation_degrees:y", -180, 0.5)
