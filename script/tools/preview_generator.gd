# res://script/tools/preview_generator.gd
# OUTIL DE DÉVELOPPEMENT (pas utilisé dans le jeu).
# Ouvre scenes/tools/preview_generator.tscn et lance-le avec F6 :
# il prend une capture de chaque niveau et l'enregistre dans res://previews/,
# puis se ferme tout seul. Relance-le chaque fois que tu modifies un niveau.
# Les images sont ensuite affichées sur les boutons de level_select.
extends Node

const PREVIEW_DIR := "res://previews"
const CAPTURE_SIZE := Vector2i(1920, 1080)
const PREVIEW_SIZE := Vector2i(480, 270)
# Nombre d'images à attendre pour que le niveau soit entièrement dessiné
const FRAMES_TO_WAIT := 3


func _ready() -> void:
	DirAccess.make_dir_recursive_absolute(PREVIEW_DIR)

	# Un SubViewport est un "écran virtuel" : on y affiche un niveau et on
	# peut en récupérer l'image, comme une photo. Doc Godot : « Viewports ».
	var viewport := SubViewport.new()
	viewport.size = CAPTURE_SIZE
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	add_child(viewport)

	for level_number in range(1, GameMode.level_count() + 1):
		var level: Node = load(GameMode.level_path(level_number)).instantiate()
		# On retire le GameManager AVANT d'afficher le niveau : sinon il
		# redirigerait vers le niveau sauvegardé.
		level.get_node("GameManager").free()
		viewport.add_child(level)

		# "await" met la fonction en pause jusqu'à ce que l'image soit dessinée
		for i in FRAMES_TO_WAIT:
			await RenderingServer.frame_post_draw

		var image := viewport.get_texture().get_image()
		image.resize(PREVIEW_SIZE.x, PREVIEW_SIZE.y, Image.INTERPOLATE_LANCZOS)
		var path := "%s/level_%d.png" % [PREVIEW_DIR, level_number]
		image.save_png(path)
		print("Aperçu enregistré : ", path)

		level.free()

	get_tree().quit()
