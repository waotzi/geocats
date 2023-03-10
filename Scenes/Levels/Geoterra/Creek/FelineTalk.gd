extends Area2D

onready var chat_with = get_tree().get_current_scene().chat_with
onready var player =  get_tree().get_current_scene().player


func _ready():
	connect("body_entered", self, "_on_body_entered")

var started : bool = false

func _on_body_entered(body):
	if body.name  == "Player" and not "feline_creek" in PROGRESS.dialogues:
		started = true
		chat_with.start("feline_creek", true)
		player.disable("feline_creek", true)
		chat_with.visible = true
		PROGRESS.dialogues.feline_creek = true
	
func _process(_delta):
	if started and not chat_with.started:
		player.enable("feline_creek")

