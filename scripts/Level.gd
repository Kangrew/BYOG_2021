extends Node2D
class_name Level

export var start_pos_path : NodePath;
export var node_to_reset = [];

onready var start_pos : Position2D = get_node(start_pos_path);

func reset():
	for i in node_to_reset.size():
		var r = get_node(node_to_reset[i]);
		r.reset();
	pass
