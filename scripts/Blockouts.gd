extends Node2D
class_name Blockouts

export var player_path : NodePath;
export var audio_manager_path : NodePath;
export var levels : Array;

onready var player : Sprite = get_node(player_path);
onready var audio_manager : AudioManager = get_node(audio_manager_path);

onready var next_lev_index : int = 0;
onready var current_lev : Level;

export var tween_path : NodePath;
onready var tween : Tween = get_node(tween_path);

export var blackscreen_path : NodePath;
onready var blackscreen : Sprite = get_node(blackscreen_path);

export var load_anim_duration : float = 2;

func _ready():
	load_level();

func reset_current_level():
	current_lev.reset();

func on_player_death():
	if(audio_manager != null):
		audio_manager.PlayDeathSFX();

func blockSFX():
	if(audio_manager != null):
		audio_manager.PlayZoopSFX();

func keySFX():
	if(audio_manager != null):
		audio_manager.PlayKeySFX();

func beatSFX():
	if(audio_manager != null):
		audio_manager.PlayBeatSFX();
	
func load_level() -> void:
	if(audio_manager != null):
		audio_manager.PlayGoalSFX();
	
	if get_child_count() > 0:
		get_child(0).queue_free();
		next_lev_index+=1;
	
	player.reset_beats();
	player.is_player_ready = false;
	player.direction_vector = Vector2.ZERO;
	
	tween.interpolate_property(blackscreen, "scale", Vector2(1, 0), Vector2.ONE, load_anim_duration / 2, Tween.TRANS_EXPO, Tween.EASE_OUT);
	tween.interpolate_property(blackscreen, "scale", Vector2.ONE, Vector2(0, 1), load_anim_duration / 2, Tween.TRANS_EXPO, Tween.EASE_OUT, load_anim_duration / 2);
	tween.interpolate_callback(self, load_anim_duration / 2, "start_level");
	tween.interpolate_property(blackscreen, "scale", Vector2(1, 0), Vector2(1, 0), 0, Tween.TRANS_EXPO, Tween.EASE_OUT, load_anim_duration);
	tween.start();

func start_level():
	player.rotation_degrees = 0;
	var ins = levels[next_lev_index].instance();
	self.call_deferred("set_child", ins);

func set_child(ins):
	self.add_child(ins);
	current_lev = ins;
	player.global_position = current_lev.start_pos.global_position;
