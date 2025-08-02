extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shades: MeshInstance3D = $Head/Shades

var health: int = 10
var new_health: int = 10

func _ready() -> void:
	SignalBus.next_round_started.connect(_next_round_started)
	SignalBus.defended_against_attack.connect(_update_health)

func _update_health(received_health):
	new_health = received_health

func _next_round_started(state):
	var shades_material: StandardMaterial3D = shades.get_active_material(0)
	if state == Game.STATE.Attack and new_health >= health:
		shades_material.uv1_offset.x = 0.67
		animation_player.play("laugh") # Laughs if the attack was successfully defended against
	elif state == Game.STATE.Attack and new_health < health:
		shades_material.uv1_offset.x = 0.33
		animation_player.play("angry") # Gets mad if it hurts
	else:
		shades_material.uv1_offset.x = 0.0
		animation_player.play("idle") # Otherwise, they're just vibin'...
	health = new_health
