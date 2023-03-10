extends AreaInteract
class_name ChatNPC, "res://Assets/UI/Debug/chat_npc_icon.png"

onready var current_scene = get_tree().get_current_scene()
onready var player = current_scene.player
onready var chat_with = current_scene.chat_with
onready var dialogue = current_scene.dialogue

export(bool) var has_parent = false
export(String) var enable_var = ""
export(String) var skip_var = ""
export(String) var character_name = name
export(String, FILE, "*.json") var json_file = ""
export(String, FILE, "*.ogg, *.wav") var sound_file = ""
export(float, 0, 100) var sound_volume = 100
export(bool) var trigger_on_touch = false
export(String) var player_disable = ""

func _get_default_path():
	return json_file.split('.json')[0]

func _ready():
	if json_file.empty():
		disabled = true
	else:
		var file2Check = File.new()
		if sound_file.empty():
			if file2Check.file_exists(_get_default_path() + ".ogg"):
				sound_file = _get_default_path() + ".ogg"
			elif file2Check.file_exists(_get_default_path() + ".wav"):
				sound_file = _get_default_path() + ".wav"


var active : bool
var completed :bool
func show_chat():
	current_scene.chatting.append(character_name)
	active = true

	chat_with.visible = true
	chat_with.get_node("Label").text = character_name
	current_scene.set_disable("e_interact", "chat_npc")

func hide_chat():
	current_scene.chatting.erase(character_name)
	if current_scene.chatting.size() == 0:
		current_scene.set_disable("e_interact", "chat_npc", false)
		active = false
		chat_with.visible = false
		dialogue.exit()
		dia_started = false

func _is_enabled():
	var flag = false
	if enable_var.empty():
		flag = true
	elif PROGRESS.variables.get(enable_var):
		flag = PROGRESS.variables.get(enable_var)
	if flag == false:
		return false
	else:
		if skip_var.empty():
			flag = false
		elif PROGRESS.variables.get(skip_var):
			flag = PROGRESS.variables.get(skip_var)
		else:
			flag = false
		if flag == true:
			return false
		else:
			return not current_scene.is_disabled("chat_with")
			
func _process(_delta):
	if trigger_on_touch and _is_enabled():
		if touching and not active:
			start_chat()

			if not player_disable.empty():
				current_scene.set_disable("player", player_disable)
			current_scene.set_disable("e_interact", "chat_npc")
			active = true

		if dia_started and dialogue.modulate.a == 0:
			current_scene.set_disable("e_interact", "chat_npc", false)
			dia_started = false
			active = false
			if not skip_var.empty():
				PROGRESS.variables[skip_var] = true
			if not player_disable.empty():
				current_scene.set_disable("player", player_disable, false)
	else:
		if touching and not active and not disabled and _is_enabled():
			if has_parent and get_parent().is_on_floor() or not has_parent:
				show_chat()

		elif (disabled or not touching) and active:
			hide_chat()
	if dia_started and dialogue.modulate.a == 0:
		dia_started = false
	if has_parent and "idle" in get_parent():
		get_parent().idle = true if dia_started else false


func start_chat():
	dialogue.initiate(json_file)
	dialogue.modulate.a = 0.1
	dia_started = true

	chat_with.visible = false

	AudioManager.play_sound(sound_file, sound_volume)

var dia_started
func _input(_event):
	if not trigger_on_touch:
		if touching and json_file and Input.is_action_just_pressed("interact") and dialogue.modulate.a == 0 and _is_enabled():
			if chat_with.visible:
				start_chat()
			else:
				active = false
				completed = true
				return

	
