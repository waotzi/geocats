extends E_Interact

class_name Consumable, "res://Assets/UI/Debug/consumable_icon.png"

export(NodePath) var make_node_visible
export(NodePath) var consumable_path
export(String) var progress_var

var consumable
var ui_node

func _ready():
	hide_when_playing = false
	ui_node = get_node(make_node_visible)

	if consumable_path:
		consumable = get_node(consumable_path)

	if progress_var:
		if PROGRESS.variables.get(progress_var):
			consumable.visible = false
			disabled = true

func _process(_delta): 
	if do_something  and ui_node.modulate.a == 1:
		do_something = false
		disabled = true
		ui_node.visible = false
		remove_child(button.get_parent())
		if not disable_player.empty():
			current_scene.set_disable("player", disable_player, false)
		return
	
	if do_something and not disabled:
		timer = 0
		if consumable.visible:
			utils.tween(ui_node, "fade", 1, 0.2)
		else:
			utils.tween(ui_node, "fade", 0, 0.2)
		if progress_var:
			PROGRESS.variables[progress_var] = true
		if consumable:
			consumable.visible = false
		do_something = false
		disable_sound = true
		

