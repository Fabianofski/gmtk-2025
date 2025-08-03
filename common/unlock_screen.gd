extends Node3D

var card_prefab = preload("res://cards/card.tscn")

func _init():
	SignalBus.card_unlocked.connect(card_unlock)

func card_unlock(cards: Array[Card]):
	print("Unlocked ", cards)
	var card_count = cards.size()
	var spacing = 1.25 
	var start_x = -(card_count - 1) * 0.5 * spacing

	var tween
	for i in range(card_count):
		var c = cards[i]
		var card = card_prefab.instantiate()
		card.position = Vector3(start_x + i * spacing, 0, 0)
		self.add_child(card)
		card.emit_signal("update", c)
		card.make_unlock_text_visible()

		tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "scale", Vector3.ONE, 0.5)

	await get_tree().create_timer(5).timeout

	tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "scale", Vector3.ZERO, 0.5)
	await get_tree().create_timer(2).timeout

	for child in self.get_children():
		child.queue_free()
