extends Node
class_name States

# all possible character states
enum STATES{IDLE, RUNNING, DODGING, KNOCKBACK}

@onready var allow_state_switch = true
@onready var player_state = STATES.IDLE

func switch_to(state_to_switch_to: STATES):
	if  allow_state_switch == true :
		player_state = state_to_switch_to
		
func enable_switch():
	allow_state_switch = true
	
func disable_switch():
	allow_state_switch = false
