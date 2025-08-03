extends Control

var card_prefab = preload("res://cards/card_unlock.tscn")
@onready var parent: Control = $"Unlocks"

func _init():
	SignalBus.card_unlocked.connect(card_unlock)

func card_unlock(cards: Array[Card]):
	var card_count = cards.size()
	if card_count <= 0: 
		return

	self.visible = true
	for i in range(card_count):
		var c = cards[i]
		var card = card_prefab.instantiate()
		parent.add_child(card)
		card.emit_signal("update", c)

func deactivate_screen():
	self.visible = false
	for child in parent.get_children():
		child.queue_free()
