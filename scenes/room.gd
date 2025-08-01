extends Node3D

@onready var decoration: Node3D = $Decoration

func _ready() -> void:
	SignalBus.next_round_started.connect(_switch_sides)

func _switch_sides(state) -> void:
	if state == Game.STATE.Attack:
		decoration.rotation_degrees.y = 0
	else:
		decoration.rotation_degrees.y = -180
