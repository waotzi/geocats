extends Node2D


onready var sprite = $AnimatedSprite
onready var notes = $Notes
onready var laugh = $Laugh
onready var ouch = $Ouch

var complete = false
func _ready():
	sprite.play()
	for note in notes.get_children():
		var sound = note.get_node("Sound")

		sound.set_volume_db(-30)
	print(global.pumpkin_code)
	
	if complete:
		sprite.animation = "Happy"

var shake : int = 0
var shake_direction : int = 1
func _process(delta):
	if shake > 0:
		shake_direction *= -1
		sprite.offset.x += 5 * shake_direction
		shake -= delta
	else:
		sprite.offset.x = 0

var input_code = ""
func _input(event):
	if visible and not complete and shake <= 0:
		for note in notes.get_children():
			var spr = note.get_node("Sprite")
			var btn = note.get_node("Button")
			var sound = note.get_node("Sound")
			if btn.is_hovered():
				spr.visible = true
				spr.frame = int(note.name) + 6
			else:
				spr.visible = false
			if event is InputEventMouseButton:
				if event.pressed:
					pass
				else:
					if btn.pressed:
						spr.frame = int(note.name) - 1
						sound.play()
						input_code += note.name
						if input_code.length() == global.pumpkin_code.length():
							if input_code == global.pumpkin_code:
								laugh.play()
								sprite.animation = "Happy"
								complete = true
								spr.visible = false
							else:
								shake_direction = round(rand_range(0, 1))
								if shake_direction == 0:
									shake_direction -= 1
								shake = 20
								spr.visible = false
								sound.stop()
								ouch.play()
							input_code = ""
							

