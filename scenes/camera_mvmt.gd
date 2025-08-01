extends Camera3D

@onready var camera = $"."
@onready var time_travel_fx: ColorRect = $"Time Travel Effect"
const MOUSE_SENS = 0.00004 # Magic numbers!

var base_pos: Vector3

func _ready():
	SignalBus.next_round_started.connect(_switch_sides)
	time_travel_fx.modulate.a = 0
	base_pos = camera.position

func _input(event):
	if event is InputEventMouseMotion:
			camera.rotate_y(-event.relative.x * MOUSE_SENS)
			if camera.rotation_degrees.x > -15.1:
				camera.rotate_x(-event.relative.y * (MOUSE_SENS * 2.5))
			elif camera.rotation_degrees.x <= -15.1:
				camera.rotation_degrees.x = -15.0
			camera.rotation.z = 0 # NOTE: When the player switches sides, instead of rotating the camera, rotate the decorations. EZ!

func _switch_sides(state):
	camera.position += Vector3(0, 1, -1)
	time_travel_fx.modulate.a = 1.0
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_parallel(true)
	tween.tween_property(self, "position", base_pos, 1)
	tween.tween_property(time_travel_fx, "modulate:a", 0.0, 2)
