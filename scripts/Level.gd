extends Node2D
class_name Level

export var start_pos_path : NodePath;

onready var start_pos : Position2D = get_node(start_pos_path);
