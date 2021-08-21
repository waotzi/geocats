extends CanvasLayer

onready var chat_with = $ChatWith
onready var Sprite = $ViewportContainer/Viewport/AnimatedSprite
onready var Container = $Container
onready var MusicPlayer = $AudioStreamPlayer


var location : int
var scene : String 
var prev_scene : String
var timer : int
var load_time : int = 40
var change : bool


func _get_scene():
	var pos = null
	var dir = 1
	match scene:
		"TitleScreen":
			return ["res://Scenes/Levels/0_TitleScreen/TitleScreen.tscn", pos, dir]
		"CatCradle":
			match location:
				1: 
					pos = Vector2(25, 950 * 0.7)
			return ["res://Scenes/Levels/1_CatCradle/1_CatCradle.tscn", pos, dir]
		"Complex":
			match location:
				1: 
					pos = Vector2(400, 1077)
			return ["res://Scenes/Levels/2_Complex/2_Complex.tscn", pos, dir]
		"GeoCity":
			match location:
				1: 
					pos = Vector2(2630, 1010)
				2:
					pos = Vector2(1023, 1010)
			return ["res://Scenes/Levels/3_GeoCity/3_GeoCity.tscn", pos, dir]
		"PopNnip":
			match location:
				1: 
					pos = Vector2(720, 423)
			return ["res://Scenes/Levels/4_PopNnip/4_PopNnip.tscn", pos, dir]
		"Arcade":
			return ["res://Scenes/Levels/4_PopNnip/Arcade.tscn", pos, dir]
		"DonutShop":
			return ["res://Scenes/Levels/5_DonutShop/5_DonutShop.tscn", pos, dir]
		"Creek":
			match location:
				1: 
					pos = Vector2(5500, 4120)
				2:
					pos = Vector2(2950, 3460)
				3:
					pos = Vector2(8800, 4900)
				4:
					dir = -1
					pos = Vector2(8900, 950)
			return ["res://Scenes/Levels/6_Creek/6_Creek.tscn", pos, dir]
		"CavityPuzzleRoom":	
			return ["res://Scenes/Levels/6_Creek/1_CavityPuzzleRoom.tscn", pos, dir]
		"JokeRoom":	
			return ["res://Scenes/Levels/6_Creek/2_JokeRoom.tscn", pos, dir]
		"GeoCacheRoom":	
			return ["res://Scenes/Levels/6_Creek/3_GeoCacheRoom.tscn", pos, dir]
		"Mountain":	
			return ["res://Scenes/Levels/7_Mountain/7_Mountain.tscn", pos, dir]

	
func change_scene(new_scene, new_location, sound, volume):
	if not sound == "":
		MusicPlayer.stream = load("res://Assets/Sfx/Transition/" + sound + ".ogg")
		MusicPlayer.stream.set_loop(false)
		MusicPlayer.set_volume_db(linear2db(volume))
		MusicPlayer.play()
	get_tree().paused = true
	prev_scene = scene
	scene = new_scene
	location = new_location
	
	change = true
	Sprite.visible = true
	Container.visible = true

func _physics_process(_delta):
	if change:
		timer += 1
		if timer  > load_time:
			_new_scene()
	if global.data.player_hp < 1:
		chat_with.start("feline_emergency_teleport")
		chat_with.visible = true
		get_tree().paused = true
	else:
		chat_with.visible = false

func _input(event):
	if chat_with.visible:
		if event.is_action_pressed("ui_accept") or event.is_action_pressed("interact"):
			chat_with.visible = false
			global.data.player_hp = 100.0
			change_scene(get_tree().get_current_scene().name, 0, "", 1)
	
func _new_scene():
	timer = 0
	Sprite.visible = false
	Container.visible = false
	if scene != "TitleScreen" and scene != "Splash":
		global.data.scene = scene
		global.data.location = location
		global.data.nav_unlocked[scene] = true
	var scene_data = _get_scene()

	get_tree().change_scene(scene_data[0])

	global.player_position = scene_data[1]
	global.player_direction = scene_data[2]

	get_tree().paused = false
	change = false



