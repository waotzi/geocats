extends CanvasLayer


onready var Sprite = $ViewportContainer/Viewport/AnimatedSprite
onready var Container = $Container
onready var MusicPlayer = $AudioStreamPlayer2D

var location : int
var scene : String 
var prev_scene : String
var timer : int
var load_time : int 
var change : bool


func _get_scene():
	var pos = null
	var dir = 1
	match scene:
		"CatCradle":
			match location:
				1: 
					pos = Vector2(25, 500)
					dir = 1
			return ["res://Scenes/1_CatCradle/1_CatCradle.tscn", pos, dir]
		"Complex":
			match location:
				1: 
					pos = Vector2(400, 1077)
					dir = 1
			return ["res://Scenes/2_Complex/2_Complex.tscn", pos, dir]
		"GeoCity":
			match location:
				1: 
					pos = Vector2(2630, 1010)
					dir = 1
			return ["res://Scenes/3_GeoCity/3_GeoCity.tscn", pos, dir]
		"PopNnip":
			match location:
				1: 
					pos = Vector2(720, 423)
					dir = 1
			return ["res://Scenes/4_PopNnip/4_PopNnip.tscn", pos, dir]


func _ready():
	timer = OS.get_ticks_msec() * 0.01
	
func change_scene(new_scene, new_location):
	MasterAudio.stream_paused = false
	get_tree().paused = true
	prev_scene = scene
	scene = new_scene
	location = new_location
	
	load_time = timer + 10
	change = true
	Sprite.visible = true
	Container.visible = true

func _physics_process(delta):

	timer = OS.get_ticks_msec() * 0.01
	if change:
		if timer  > load_time:
			_new_scene()
	
func _new_scene():
	Sprite.visible = false
	Container.visible = false
	data.file_data.scene = scene
	data.file_data.location = location
	var scene_data = _get_scene()
	get_tree().change_scene(scene_data[0])
	global.player_position = scene_data[1]
	global.player_direction = scene_data[2]

	get_tree().paused = false
	change = false

	MasterAudio.stream = null


