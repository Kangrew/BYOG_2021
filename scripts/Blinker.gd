extends Area2D

export var wait_time : float = 1;
export var dissolve_time : float = 1;

onready var blockSprite : Sprite = $Sprite;
onready var tween : Tween = $Tween;
onready var collisionShape : CollisionShape2D = $CollisionShape2D;

var isActive : bool = true;

func _ready():
	delay_call_pop();
	pass # Replace with function body.

func _on_Blinker_area_shape_entered(area_id, area, area_shape, local_shape):
	if area.is_in_group("Player") and isActive:
		var player : Player = area.get_parent();
		player.die();
		pass
	pass # Replace with function body.

func delay_call_pop():
	tween.interpolate_callback(self, wait_time, "popAnimation");
	tween.start()
	pass

func popAnimation():
	if(isActive):
		isActive = false;
		switchColor(Color(1,1,1,1),Color(1,1,1,0.1),1, 0.7,dissolve_time);
	else:
		isActive = true;
		switchColor(Color(1,1,1,0.1),Color(1,1,1,1),0.7,1,dissolve_time);
	pass

func switchColor(aColor, bColor,scaleDown, scaleUp, seconds):
	var transitionType = Tween.TRANS_LINEAR;
	
	if(isActive):
		 transitionType  = Tween.TRANS_BOUNCE;
	
	tween.interpolate_property(blockSprite, "self_modulate",aColor,bColor, seconds, Tween.TRANS_LINEAR, Tween.EASE_IN);
	tween.interpolate_property(blockSprite, "scale", Vector2(scaleDown,scaleDown), Vector2(scaleUp,scaleUp), seconds, transitionType, Tween.EASE_OUT);
	tween.start();
	delay_call_pop();
	pass
