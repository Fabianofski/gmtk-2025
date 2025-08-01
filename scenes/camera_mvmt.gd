extends Camera3D

@onready var camera = $"."
const MOUSE_SENS = 0.00004 # Magic numbers!

func _ready():
	SignalBus.next_round_started.connect(switch_sides)

func _input(event):
	if event is InputEventMouseMotion:
			camera.rotate_y(-event.relative.x * MOUSE_SENS)
			camera.rotate_x(-event.relative.y * (MOUSE_SENS * 2.5))
			camera.rotation.z = 0 # NOTE: When the player switches sides, instead of rotating the camera, rotate the decorations. EZ!

func switch_sides(state): 
	match(state): 
		Game.STATE.Attack: 
			pass 
		Game.STATE.Defense: 
			pass
