extends AnimationTree
@onready var stats = $"../../Stats"
const speed_const = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	update_time_scale()

# Updates the time scale of the animation every physics tick, in the event that the charc=acter stats are changed this function updates the asocaiated timescalee
func update_time_scale():
	# dodge animation
	var dodge_animation = $"../AnimationPlayer".get_animation("dodge")
	var dodge_duration_ratio =  dodge_animation.length / stats.evade_dur
	set("parameters/dodge/dodge_speed/scale",dodge_duration_ratio)
	
	var run_animation = $"../AnimationPlayer".get_animation("run")
	var run_speed_ratio =  stats.speed / (run_animation.length*speed_const)
	set("parameters/run/run_speed/scale", run_speed_ratio)
	
	var swap_animation = $"../AnimationPlayer".get_animation("swap")
	var swap_speed_ratio = swap_animation.length / stats.swap_dur
	set("parameters/swap/swap_speed/scale", swap_speed_ratio)
	
	
	
	
	pass
