@tool
extends EditorScript

func _run():
	var node = get_scene().get_node("Player Hand/Deck") 
	var cards_folder = "res://cards/res"
	
	var cards = look_for_cards(cards_folder)	
	node.cards = cards
	print("Done. Imported %d cards." % cards.size())

func look_for_cards(cards_folder): 
	var dir := DirAccess.open(cards_folder)
	var cards = []
	if dir:
		dir.list_dir_begin()
		while true:
			var file_name = dir.get_next()
			var path = cards_folder + "/" + file_name
			if file_name == "":
				break
			if dir.current_is_dir():
				cards.append_array(look_for_cards(path))
			if file_name.ends_with(".tres") or file_name.ends_with(".res"):
				var card = load(path)
				if card is Resource:
					cards.append(card)
		dir.list_dir_end()

	return cards
