extends Position2D

enum States { IDLE, FOLLOW }

const ARRIVE_DISTANCE = 1

export(float) var speed = 100
var _state = States.IDLE

onready var obstacles_path = get_parent().get_parent().get_node("Obstacles")

var _path = []
var _target_point_world = Vector2()
var _target_position = Vector2()
var _velocity = Vector2()
var _is_chosen = false


func _ready():
	_change_state(States.IDLE)
	sprite_hide($Ready_icon)


func _process(_delta):
	if _state != States.FOLLOW:
		return
	var _arrived_to_next_point = _move_to(_target_point_world)
	if _arrived_to_next_point:
		_path.remove(0)
		if len(_path) == 0:
			_change_state(States.IDLE)
			return
		_target_point_world = _path[0]


func sprite_show(sprite):
	if !sprite.visible:
		sprite.visible = not sprite.visible
	
func sprite_hide(sprite):
	if sprite.visible:
		sprite.visible = not sprite.visible

func _unhandled_input(event):
	if event.is_action_pressed("click"):
			var global_mouse_pos = get_global_mouse_position()
			var mouse_pos = obstacles_path.world_to_map(global_mouse_pos)
			var hero_pos =  obstacles_path.world_to_map(global_position)
			if mouse_pos == hero_pos:
				if obstacles_path.is_clickable == true:
					_is_chosen = true
					obstacles_path.units_become_obstacles()
					sprite_show($Ready_icon)
					obstacles_path.is_clickable = false
					return
			if _is_chosen == true:
				_target_position = global_mouse_pos
				_change_state(States.FOLLOW)
				_is_chosen = false
				sprite_hide($Ready_icon)
				obstacles_path.units_are_not_obstacles()
				yield(get_tree().create_timer(0.01), "timeout") #delay
				obstacles_path.is_clickable = true
			
	
	if event.is_action_pressed("right_click"):
		if _is_chosen == true:
			obstacles_path.units_are_not_obstacles()
			obstacles_path.is_clickable = true
		_is_chosen = false
		sprite_hide($Ready_icon)
		

func _move_to(world_position):
	var desired_velocity = (world_position - position).normalized() * speed
	var steering = desired_velocity - _velocity
	_velocity += Vector2(steering)
	position += _velocity * get_process_delta_time()
	return position.distance_to(world_position) < ARRIVE_DISTANCE


func _change_state(new_state):
	var is_walkable = true
	if new_state == States.FOLLOW:
		_path = obstacles_path.get_astar_path(position, _target_position)
		var _last_point = obstacles_path.world_to_map(_target_position)	
		for i in range(len(obstacles_path.obstacles)):
			if _last_point == obstacles_path.obstacles[i]:
				is_walkable = false
				break
		if not _path or len(_path) == 1 or !is_walkable :
			_change_state(States.IDLE)
			_path = []
			return
		# The index 0 is the starting cell.
		# We don't want the character to move back to it in this example.
		_target_point_world = _path[1]
	_state = new_state

	
