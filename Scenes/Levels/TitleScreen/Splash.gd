extends Control

onready var splash = $AnimatedSprite
onready var audio = $AudioStreamPlayer

var particles
var loaded

func _ready():
	if Utils.get_season() == "Winter":
		particles = Utils.particle_emitter["snow"].instance()
		particles.preprocess = false
	Utils.tween_fade(splash, 0, 1)
	add_child(particles)
	loaded = true

func _next():
	SceneChanger.change_scene("TitleScreen")
	remove_child(particles)

func _process(_delta):
	if splash.frame == 77:
		_next()
	if loaded:
		splash.play()
		audio.play()
		loaded = false

func _input(event):
	if event.is_action_pressed("escape") or event.is_action_pressed("interact") or event.is_action_pressed("jump"):
		_next()
