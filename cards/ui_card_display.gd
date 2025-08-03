extends Control 

@onready var front: TextureRect = $front
@onready var background: TextureRect = $card_bg

@export var standard_bg: Texture2D; 
@export var silver_bg: Texture2D; 
@export var gold_bg: Texture2D; 
@export var crystal_bg: Texture2D; 

@onready var card_number_display: Label = $"Card Number"
@onready var atk_def_holder: Control = $ATK_DEF
@onready var atk_display: Label = $"ATK_DEF/atk"
@onready var atk_icon: TextureRect = $"ATK_DEF/atk_icon"
@onready var dfs_display: Label = $"ATK_DEF/dfs"
@onready var dfs_icon: TextureRect = $"ATK_DEF/dfs_icon"
@export var score_texture: Texture2D; 

@onready var special_holder: Control = $Special
@onready var special_display: Control = $"Special/sp"

signal update

func _init():
	update.connect(update_card)	

func update_card(card: Card): 
	front.texture = card.sprite
	card_number_display.text = str(card.score)
	match card_number_display.text:
		"11":
			card_number_display.text = "J"
		"12":
			card_number_display.text = "Q"
		"13":
			card_number_display.text = "K"
		"14":
			card_number_display.text = "A"

	if card.suit == Card.Suits.Diamond or card.suit == Card.Suits.Heart:
		card_number_display.modulate = Color("#E64539")
	else:
		card_number_display.modulate = Color("BLACK")

	match card.rarity: 
		Card.Rarity.Standard: 
			background.texture = standard_bg
		Card.Rarity.Silver: 
			background.texture = silver_bg
		Card.Rarity.Gold: 
			background.texture = gold_bg 
		Card.Rarity.Crystal: 
			background.texture = crystal_bg

	match card.type: 
		Card.CardType.Standard: 
			atk_display.text = str(card.attack)
			dfs_display.text = str(card.defense)
			atk_def_holder.visible = true
			special_holder.visible = false
		Card.CardType.Multiplier:
			if card.attack_multiplier != 1: 
				atk_display.text = "%dx" % card.attack_multiplier
			else:
				atk_display.text = "%dx" % card.score_multiplier
				atk_icon.texture = score_texture
			if card.defense_multiplier != 1: 
				dfs_display.text = "%dx" % card.defense_multiplier
			else:
				dfs_display.text = "%dx" % card.score_multiplier
				dfs_icon.texture = score_texture
			atk_def_holder.visible = true
			special_holder.visible = false
			if card.explanation != "": # Should the "explanation" field not be empty...
				special_display.text = card.explanation
				atk_def_holder.visible = false
				special_holder.visible = true
		Card.CardType.Signal: 
			special_display.text = card.explanation
			atk_def_holder.visible = false
			special_holder.visible = true
