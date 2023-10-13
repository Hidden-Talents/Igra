extends Camera2D

var speed = 1
var left_barier
var right_barier
var up_barier
var down_barier
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if Input.is_action_pressed("cam_left"):
		offset.x -= speed
	if Input.is_action_pressed("cam_right"):
		offset.x += speed
	if Input.is_action_pressed("cam_up"):
		offset.y -= speed
	if Input.is_action_pressed("cam_down"):
		offset.y += speed;

#func _input(event):
#	if event.is_action_pressed("cam_left"):
#		offset.x -= speed
#	if event.is_action_pressed("cam_right"):
#		offset.x += speed
#	if event.is_action_pressed("cam_up"):
#	if event.is_action_pressed("cam_down"):
#		offset.y += speed;
