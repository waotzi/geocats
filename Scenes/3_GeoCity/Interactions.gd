extends Area2D

onready var button = $Button
onready var sound = $Sound
onready var player =  get_tree().get_current_scene().get_node("Player")

func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

func _on_body_entered(body):
	if body.name == "Player":
		button.visible = true

func _on_body_exited(body):
	if body.name == "Player":
		button.visible = false

func _input(event):
	if Input.is_action_just_pressed("ui_down") && button.visible == true:
		button.visible = false
		if name == "GoToComplex":
			SceneChanger.change_scene("Complex", 1, "FootstepsOnGravelFast", 1.5)
		if name == "PopNnip":
			SceneChanger.change_scene("PopNnip", 0, "WayoWayo", .5)