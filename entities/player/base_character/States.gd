extends Node
class_name States

# all possible character states
enum STATES{IDLE, RUNNING, DODGING}

@onready var allow_state_swtich = true
@onready var player_state = STATES.IDLE

func switch_to(state_to_swtich_to: STATES):
	if  allow_state_swtich == true :
		player_state = state_to_swtich_to
		
func enable_switch():
	allow_state_swtich = true
	
func disable_switch():
	allow_state_swtich = false
