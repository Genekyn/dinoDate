# res://script/level_select.gd
# Écran de choix du niveau pour le contre-la-montre.
# Les boutons de niveau ne sont PAS dans la scène : ils sont créés par le code
# (_build_page). Avantage : ajouter un level_17.tscn ajoute automatiquement
# un bouton, et une 3e page si besoin.
extends Control

const LEVELS_PER_PAGE := 8
const LEVEL_BUTTON_SIZE := Vector2(340, 220)
# Aperçus générés par scenes/tools/preview_generator.tscn (optionnels :
# s'il n'y a pas d'image, le bouton affiche seulement le texte).
const PREVIEW_PATH_FORMAT := "res://previews/level_%d.png"

@onready var chain_check_button: CheckButton = $VBoxContainer/ChainCheckButton
@onready var level_grid: GridContainer = $VBoxContainer/LevelGrid
@onready var prev_button: Button = $VBoxContainer/PageBar/PrevButton
@onready var next_button: Button = $VBoxContainer/PageBar/NextButton
@onready var page_label: Label = $VBoxContainer/PageBar/PageLabel
@onready var back_button: Button = $VBoxContainer/BackButton

var _page := 0
var _page_count := 1


func _ready() -> void:
	var level_count := GameMode.level_count()
	# ceili = division arrondie au-dessus : 16 niveaux / 8 = 2 pages, 17 = 3 pages
	_page_count = maxi(1, ceili(level_count / float(LEVELS_PER_PAGE)))
	# On garde le choix "Enchaîner" d'une visite à l'autre (stocké dans l'autoload)
	chain_check_button.button_pressed = GameMode.chain_levels

	prev_button.pressed.connect(_change_page.bind(-1))
	next_button.pressed.connect(_change_page.bind(1))
	back_button.pressed.connect(GameMode.go_to_menu)
	_build_page()


func _input(event: InputEvent) -> void:
	# Échap / Start : retour au menu
	if event.is_action_pressed("openMenu"):
		GameMode.go_to_menu()
		return
	# Gâchettes LB / RB de la manette : page précédente / suivante.
	# On teste directement le bouton de la manette, sans passer par une action.
	# "as" convertit l'événement en bouton de manette (null si c'en est pas un).
	var joypad_event := event as InputEventJoypadButton
	if joypad_event and joypad_event.pressed:
		if joypad_event.button_index == JOY_BUTTON_LEFT_SHOULDER:
			_change_page(-1)
		elif joypad_event.button_index == JOY_BUTTON_RIGHT_SHOULDER:
			_change_page(1)


func _change_page(direction: int) -> void:
	# clampi garde la valeur entre 0 et la dernière page
	var new_page := clampi(_page + direction, 0, _page_count - 1)
	if new_page != _page:
		_page = new_page
		_build_page()


func _build_page() -> void:
	# On supprime les boutons de la page précédente
	for child in level_grid.get_children():
		child.queue_free()

	var first_level := _page * LEVELS_PER_PAGE + 1
	var last_level := mini(first_level + LEVELS_PER_PAGE - 1, GameMode.level_count())
	var first_unlocked_button: Button = null

	for level_number in range(first_level, last_level + 1):
		var button := _create_level_button(level_number)
		level_grid.add_child(button)
		if first_unlocked_button == null and not button.disabled:
			first_unlocked_button = button

	page_label.text = "%d / %d" % [_page + 1, _page_count]
	prev_button.disabled = _page == 0
	next_button.disabled = _page == _page_count - 1

	# Focus pour la manette : premier niveau jouable, sinon le bouton Back
	if first_unlocked_button:
		first_unlocked_button.grab_focus()
	else:
		back_button.grab_focus()


func _create_level_button(level_number: int) -> Button:
	var button := Button.new()
	button.custom_minimum_size = LEVEL_BUTTON_SIZE

	if not SaveSystem.is_level_unlocked(level_number):
		button.text = "LEVEL %d\nLOCKED" % level_number
		button.disabled = true
		return button

	# Meilleur temps du niveau (les scores sont déjà triés, le 1er est le meilleur)
	var scores := Leaderboard.get_scores(Leaderboard.level_category(level_number))
	var best_time := "--:--.--"
	if not scores.is_empty():
		best_time = GameMode.format_time(scores[0]["ms"])
	button.text = "LEVEL %d\n%s" % [level_number, best_time]

	var preview_path := PREVIEW_PATH_FORMAT % level_number
	if ResourceLoader.exists(preview_path):
		button.icon = load(preview_path)
		button.expand_icon = true  # l'image s'adapte à la taille du bouton
		button.vertical_icon_alignment = VERTICAL_ALIGNMENT_TOP
		button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER

	# bind() "colle" un argument à la fonction : chaque bouton appellera
	# _on_level_pressed avec SON numéro de niveau.
	button.pressed.connect(_on_level_pressed.bind(level_number))
	return button


func _on_level_pressed(level_number: int) -> void:
	GameMode.start_time_attack(level_number, chain_check_button.button_pressed)
