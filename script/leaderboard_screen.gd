# res://script/leaderboard_screen.gd
# Affiche le top 10 d'une catégorie : Speedrun, ou un niveau en contre-la-montre.
# Le tableau est un GridContainer à 3 colonnes : chaque Label ajouté prend la
# case suivante (gauche -> droite, puis ligne suivante), comme une grille de
# tableur. Doc Godot : « GridContainer ».
extends Control

const FONT_SIZE := 32
const HEADER_COLOR := Color(1.0, 0.8, 0.3)

@onready var category_option: OptionButton = $VBoxContainer/CategoryOption
@onready var score_grid: GridContainer = $VBoxContainer/ScoreGrid
@onready var back_button: Button = $VBoxContainer/BackButton

# Index dans la liste déroulante -> nom de catégorie dans Leaderboard
var _categories: Array[String] = []


func _ready() -> void:
	# 1re entrée : Speedrun, puis un choix par niveau
	_add_category("SPEEDRUN", Leaderboard.SPEEDRUN_CATEGORY)
	for level_number in range(1, GameMode.level_count() + 1):
		_add_category("LEVEL %d" % level_number, Leaderboard.level_category(level_number))

	# item_selected envoie l'index choisi à la fonction connectée
	category_option.item_selected.connect(_show_category)
	back_button.pressed.connect(GameMode.go_to_menu)

	_show_category(0)
	category_option.grab_focus()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("openMenu"):
		GameMode.go_to_menu()


func _add_category(label: String, category: String) -> void:
	category_option.add_item(label)
	_categories.append(category)


func _show_category(index: int) -> void:
	for child in score_grid.get_children():
		child.queue_free()

	# Ligne d'en-tête
	_add_cell("#", HEADER_COLOR)
	_add_cell("PSEUDO", HEADER_COLOR)
	_add_cell("TEMPS", HEADER_COLOR)

	var scores := Leaderboard.get_scores(_categories[index])
	if scores.is_empty():
		_add_cell("-")
		_add_cell("Aucun temps")
		_add_cell("-")
		return

	# rank = la place affichée : 1, 2, 3...
	var rank := 1
	for entry in scores:
		_add_cell(str(rank))
		_add_cell(entry["name"])
		_add_cell(GameMode.format_time(entry["ms"]))
		rank += 1


func _add_cell(text: String, color: Color = Color.WHITE) -> void:
	var cell := Label.new()
	cell.text = text
	cell.add_theme_font_size_override("font_size", FONT_SIZE)
	cell.add_theme_color_override("font_color", color)
	score_grid.add_child(cell)
