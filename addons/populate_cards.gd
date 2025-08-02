@tool
extends EditorScript

func _run():
	var node = get_scene().get_node("Player Hand/Deck") # z.B. "Main" oder "CardsLoader"
	var cards_folder = "res://cards/res"
	var dir := DirAccess.open(cards_folder)
	var cards = []
	
	if dir:
		dir.list_dir_begin()
		while true:
			var file_name = dir.get_next()
			if file_name == "":
				break
			if dir.current_is_dir():
				continue
			if file_name.ends_with(".tres") or file_name.ends_with(".res"):
				var card = load(cards_folder + "/" + file_name)
				if card is Resource:
					cards.append(card)
		dir.list_dir_end()
	
	node.cards = cards
