extends KinematicBody2D
class_name Entity

onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var sprite
var to_rotate
var no_rotate = false
var velocity : Vector2 = Vector2.ZERO
# one way collding platform
var current_platforms = []
var disabled_platforms = []
var fall_through_timer = 0
var fall_through_time = 30

func fall_through():
	for platform in current_platforms:
		platform.disabled = true

		disabled_platforms.insert(disabled_platforms.size(), platform)
	fall_through_timer =  OS.get_ticks_msec() * 0.001 + fall_through_time

func check_child_collision(child):
	if (child is CollisionShape2D || child is CollisionPolygon2D) && child.is_one_way_collision_enabled():
		return true
	else:
		return false


func apply_gravity (_delta: float):
	velocity.y += gravity

func _ready():
	randomize()
	if not to_rotate:
		to_rotate = sprite
func _get_rotation():
	if to_rotate is ViewportContainer:
		return deg2rad(to_rotate.rect_rotation)
	else:
		return to_rotate.rotation

func jump(jumpHeight):
	velocity.y = 0 #reset velocity
	velocity.y = -sqrt(50 * gravity * jumpHeight) 
	
func _set_rotation(rot):
	if no_rotate == false:
		if to_rotate is ViewportContainer:
			to_rotate.rect_rotation = rad2deg(rot)
		else:
			to_rotate.rotation = rot

var new_rot : float
func _physics_process(delta):
	var rot = _get_rotation()
	if fall_through_timer >  OS.get_ticks_msec() * 0.001:
		fall_through_timer -= 1
	else:
		for platform in disabled_platforms:
			platform.disabled = false
		disabled_platforms = []
	current_platforms = []
	var slide_count = get_slide_count()
	if slide_count > 0:
		new_rot = 0
		for i in slide_count:
			var collision = get_slide_collision(i)
			if is_on_floor():
				for child in collision.collider.get_children():
					if check_child_collision(child):
						current_platforms.insert(current_platforms.size(), child)
			var normal = collision.normal

			if normal.x > -.7 && normal.x < .7 and normal.y < .7:
				var slope_angle = normal.dot(Vector2(0,-1)) - 1
				var mul = 1
				if normal.x < 0:
					mul = -1
				new_rot += -slope_angle * 4 * mul
			else:
				new_rot = rot * .5

	else:
		slide_count = 1
		new_rot = rot * .5
	if rot != new_rot:
		rot = (new_rot / slide_count + rot * 3) / 4

	_set_rotation(rot)
	apply_gravity(delta)
