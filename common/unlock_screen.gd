extends Node3D 

var card_prefab = preload("res://cards/card.tscn")

func _init():
	SignalBus.card_unlocked.connect(card_unlock)

func card_unlock(cards: Array[Card]): 
	for c in cards:
		var card = card_prefab.instantiate()
		self.add_child(card)
		card.emit_signal("update", c) 

		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "scale", Vector3.ONE, 0.5)

	await get_tree().create_timer(2).timeout

	for child in self.get_children():
		child.queue_free()
