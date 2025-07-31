extends Camera3D

@onready var camera = $"."
const MOUSE_SENS = 0.00004 # Magic numbers!

func _input(event):
	if event is InputEventMouseMotion:
			camera.rotate_y(-event.relative.x * MOUSE_SENS)
			camera.rotate_x(-event.relative.y * MOUSE_SENS)
			camera.rotation.z = 0 # NOTE: When the player switches sides, instead of rotating the camera, rotate the decorations. EZ!
