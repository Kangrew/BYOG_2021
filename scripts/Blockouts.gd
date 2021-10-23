extends Node2D

export var player_path : NodePath;
export var main_cam_path : NodePath;
export var levels : Array;

onready var player : Player = get_node(player_path);
onready var main_cam : MainCamera = get_node(main_cam_path);
onready var current_lev_index : int = 0;
onready var current_lev : Level;

func reset_scene(tween : Tween) -> void:
#	tween.interpolate_property(main_cam, "global_position", main_cam.global_position, )
	pass

func load_level() -> void:
	get_child(0).queue_free();

