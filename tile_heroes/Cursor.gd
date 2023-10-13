extends Position2D

onready var obstacles_path = get_parent().get_node("Obstacles")
var active
var deny
var use
var blocked = false

func _ready():
	active = get_node("active")
	deny = get_node("deny")
	use = get_node("use")
	sprite_hide(use)
	
func _process(delta):
	blocked = false
	var global_mouse_pos = get_global_mouse_position()
	var cell = obstacles_path.world_to_map(global_mouse_pos)*16 + Vector2(8,8)
	active.position = cell
	deny.position = cell
	use.position = cell
	var point = obstacles_path.world_to_map(global_mouse_pos)
	for i in range(len(obstacles_path.obstacles)):
		if point == obstacles_path.obstacles[i]:
			blocked = true
	if blocked:
		sprite_hide(active)
		sprite_show(deny)
	else:
		sprite_hide(deny)
		sprite_show(active)
		
func _unhandled_input(event):
	if event.is_action_pressed("click"):
		sprite_show(use)
		yield(get_tree().create_timer(0.3), "timeout") #delay
		sprite_hide(use)


func sprite_show(sprite):
	if !sprite.visible:
		sprite.visible = not sprite.visible
	
func sprite_hide(sprite):
	if sprite.visible:
		sprite.visible = not sprite.visible
