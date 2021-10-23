extends Node2D
class_name Blockouts

export var player_path : NodePath;
export var levels : Array;

onready var player : Sprite = get_node(player_path);
onready var next_lev_index : int = 0;
onready var current_lev : Level;

func _ready():
	load_level();

func load_level() -> void:
	if get_child_count() > 0:
		get_child(0).queue_free();
		next_lev_index+=1;
	
	var ins = levels[next_lev_index].instance();
	player.direction_vector = Vector2.ZERO;
	self.call_deferred("set_child", ins);

func set_child(ins):
	self.add_child(ins);
	current_lev = ins;
	player.global_position = current_lev.start_pos.global_position;
