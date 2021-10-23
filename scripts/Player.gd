extends Sprite

onready var tween : Tween = $Tween;
onready var arrow : Sprite = $Arrow;
onready var beats : Node2D = $BeatsLeft;

enum directions {RIGHT, DOWN, LEFT, UP}

var is_player_ready = false;
var current_dir = directions.RIGHT;
var direction_vector = Vector2.ZERO;
var is_frozen = true;
var beats_left = 4
var die_aim_duration : float = 0.5;

export var player_speed : float = 500;

export var arrow_min_rot : float = 90.0;
export var arrow_max_pop_scale : Vector2 = Vector2(1.2, 1.2);
export var arrow_rot_duration : float = 0.5;

func _ready():
	change_dir();

func _process(delta) -> void:
	if !is_frozen:
		position += direction_vector * player_speed * delta;

func _unhandled_input(event) -> void:
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
	is_frozen = true;

func push() -> void:
	is_player_ready = true;
	is_frozen = false;
	
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
	tween.interpolate_property(self, "scale", Vector2.ONE, Vector2.ZERO, die_aim_duration, Tween.TRANS_EXPO, Tween.EASE_OUT);
	direction_vector = Vector2.ZERO;
