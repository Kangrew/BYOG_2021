extends Sprite
class_name Player

enum directions {RIGHT, DOWN, LEFT, UP}

export var player_speed : float = 500;
export var arrow_min_rot : float = 90.0;
export var arrow_max_pop_scale : Vector2 = Vector2(1.2, 1.2);
export var arrow_rot_duration : float = 0.5;
export var death_particles_path : NodePath;
export var main_cam_path : NodePath;
export var blockout_path : NodePath;
export var die_anim_duration : float = 0.5;
export var reset_duration : float = 1;
export var cam_zoom : Vector2 = Vector2.ONE;
export var cam_zoom_duration_in : float = 0.5;
export var cam_zoom_duration_out : float = 0.2;

var is_player_ready = false;
var current_dir = directions.RIGHT;
var direction_vector = Vector2.ZERO;
var is_frozen = true;
var beats_left = 4
var is_dead : bool = false;
var zoom_tween;

onready var death_particles : CPUParticles2D = get_node(death_particles_path);
onready var main_cam : MainCamera = get_node(main_cam_path);
onready var blockout : Blockouts = get_node(blockout_path);
onready var tween : Tween = $Tween;
onready var arrow : Sprite = $Arrow;
onready var beats : Node2D = $BeatsLeft;
onready var area_shape : CollisionShape2D = $Area2D/CollisionShape2D;

func _ready():
	change_dir();

func _process(delta) -> void:
	if !is_frozen:
		position += direction_vector * player_speed * delta;

func _unhandled_input(event) -> void:
	if !is_dead:
		if event.is_action_pressed("push"):
			freeze();
		elif event.is_action_released("push"):
			push();

func _on_Area2D_body_shape_entered(_body_id, body, _body_shape, _local_shape):
	if body.is_in_group("block"):
		die();

func change_dir() -> void:
	
	current_dir += 1
	if current_dir >= directions.size():
		current_dir = 0;
	
	if arrow.rotation_degrees >= 360:
		tween.interpolate_property(arrow, "rotation_degrees", 0.0, arrow_min_rot, arrow_rot_duration, Tween.TRANS_ELASTIC, Tween.EASE_OUT);
	else:
		tween.interpolate_property(arrow, "rotation_degrees", arrow.rotation_degrees, arrow.rotation_degrees + arrow_min_rot, arrow_rot_duration, Tween.TRANS_ELASTIC, Tween.EASE_OUT);
	
	if is_player_ready:
		if( beats_left == 0):
			die();
			tween.interpolate_callback(self, reset_duration, "change_dir");
			return;
		beats_left -= 1;
		beats.get_child(beats_left).visible = false;
	
	tween.interpolate_property(arrow, "scale", Vector2.ONE, arrow_max_pop_scale, arrow_rot_duration / 2, Tween.TRANS_EXPO, Tween.EASE_IN);
	tween.interpolate_property(arrow, "scale", arrow_max_pop_scale, Vector2.ONE, arrow_rot_duration, Tween.TRANS_EXPO, Tween.EASE_IN, arrow_rot_duration / 2);
	
	tween.interpolate_callback(self, arrow_rot_duration, "change_dir");
	
	tween.start();

func reset_beats() -> void:
	beats_left = beats.get_child_count();
	for beat in beats.get_children():
		beat.visible = true;

func freeze() -> void:
	tween.interpolate_property(main_cam, "zoom", Vector2.ONE, cam_zoom, cam_zoom_duration_in, Tween.TRANS_EXPO, Tween.EASE_OUT);
	is_frozen = true;
	tween.start();

func push() -> void:
	tween.stop(main_cam);
	tween.interpolate_property(main_cam, "zoom", main_cam.zoom, Vector2.ONE, cam_zoom_duration_out, Tween.TRANS_EXPO, Tween.EASE_OUT);
	is_player_ready = true;
	is_frozen = false;
	tween.start();
	
	reset_beats()
	
	if current_dir == directions.RIGHT:
		direction_vector = Vector2(1.0, 0.0);
	elif current_dir == directions.DOWN:
		direction_vector = Vector2(0.0, 1.0);
	elif current_dir == directions.LEFT:
		direction_vector = Vector2(-1.0, 0.0);
	else:
		direction_vector = Vector2(0.0, -1.0);

func die() -> void:
	is_dead = true;
	blockout.on_player_death();
	death_particles.global_position = global_position;
	death_particles.emitting = true;
	tween.interpolate_property(self, "scale", Vector2.ONE, Vector2.ZERO, die_anim_duration, Tween.TRANS_EXPO, Tween.EASE_OUT);
	tween.interpolate_property(main_cam, "global_position", main_cam.global_position, Vector2(blockout.current_lev.start_pos.global_position.x + main_cam.pos_x_offset, main_cam.global_position.y), reset_duration / 2, Tween.TRANS_ELASTIC, Tween.EASE_OUT);
	direction_vector = Vector2.ZERO;
	
	tween.interpolate_callback(self, reset_duration / 2, "reset");
	tween.start();
	blockout.reset_current_level();

func reset() -> void:
	is_dead = false;
	is_player_ready = false;
	reset_beats();
	global_position = blockout.current_lev.start_pos.global_position;
	tween.interpolate_property(self, "scale", Vector2.ZERO, Vector2.ONE, reset_duration / 2, Tween.TRANS_EXPO, Tween.EASE_OUT);
	tween.start();
