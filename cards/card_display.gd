extends Node3D
class_name CardDisplay

var card: Card = null 
var selected: bool = false
var mouse_on_card: bool = false
signal update
@onready var front: Sprite3D = $front

func _init():
	update.connect(update_card)
	SignalBus.next_round_started.connect(destroy_card)

func destroy_card(_state):
	if selected:
		queue_free()

func update_card(_card: Card): 
	card = _card
	front.texture = card.sprite

func _ready():
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)

func _unhandled_input(event):
	var left_click = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed
	if not left_click or not mouse_on_card:
		return 

	selected = not selected
	if selected: 
		SignalBus.select_card.emit(card)
	else: 
		SignalBus.deselect_card.emit(card)

func _on_mouse_entered() -> void:
	mouse_on_card = true
	position.y = 0.2
	
func _on_mouse_exited() -> void:
	mouse_on_card = false
	if not selected: 
		position.y = 0
