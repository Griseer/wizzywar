extends Node3D

@export var player:CharacterBody3D
@export var player_camera: Camera3D
@onready var pivot_camera: Node3D = $PivotCamera

var mouse_is_captured = true

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	top_level = true


func _process(_delta):
	global_position = player.global_position


func _input(event):
	#if event.is_action_released("mouse_mode_switch"):
		#switch_mouse()
	
	if event is InputEventMouseMotion and mouse_is_captured and !Input.is_action_pressed("cast"):
		var d_hor = event.relative.x
		var d_ver = event.relative.y
		rotate_y(- d_hor / 1000)
		#
		#
#
		#
		#pivot_camera.rotate_x(-d_ver / 1000 )
		#
		#if pivot_camera.rotation_degrees.x > 60:
			#pivot_camera.rotation_degrees.x= 59
		#if pivot_camera.rotation_degrees.x < -40:
			#pivot_camera.rotation_degrees.x= -39



func switch_mouse():
	if mouse_is_captured:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	mouse_is_captured = not mouse_is_captured
