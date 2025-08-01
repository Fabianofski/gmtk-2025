extends Node3D

@onready var decoration: Node3D = $Decoration

func _ready() -> void:
	SignalBus.next_round_started.connect(_switch_sides)

func _switch_sides(state):
	match state:
		Game.STATE.Attack:
			decoration.rotation_degrees.y = 0
		Game.STATE.Defense:
			decoration.rotation_degrees.y = -180
