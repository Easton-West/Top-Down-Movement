extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree

var playback : AnimationNodeStateMachinePlayback
var speed : float = 70
var direction : Vector2 = Vector2.ZERO
var SPEED : float = 100
var max_distance : int = 9
var weapon_angle : float
var mouse_position : Vector2

#NEXT CODE
func _ready() -> void:
	playback = animation_tree.get("parameters/playback")

func _physics_process(delta: float) -> void:
	mouse_position = get_global_mouse_position()
	
	direction = Input.get_vector("left", "right", "up", "down")
	
	var dir = global_position.direction_to(mouse_position)
	var angle = global_position.angle_to_point(mouse_position)
	var distance = global_position.distance_to(mouse_position)
	distance = clamp(distance, 0, max_distance)

	weapon_angle = global_position.angle_to_point(mouse_position)
	
	if rad_to_deg(weapon_angle) > -90 and rad_to_deg(weapon_angle) < 90:
		$Sword.get_child(1).flip_v = false
	elif rad_to_deg(weapon_angle) > 90 or rad_to_deg(weapon_angle) < -90:
		$Sword.get_child(1).flip_v = true
		
	$Sword.global_position = Vector2(global_position.x + distance * cos(weapon_angle), global_position.y + distance * sin(weapon_angle))
	$Sword.rotation = weapon_angle
	
	animation_tree.set("parameters/idle/BlendSpace2D/blend_position", dir.round())
	animation_tree.set("parameters/walk/blend_position", dir.round())
	
	if direction.length() != 0:
		playback.travel("walk")
	else:
		animation_tree.set("parameters/idle/TimeSeek/seek_request", 0.1)
		playback.travel("idle")

	velocity = direction * speed
	
	move_and_slide()
