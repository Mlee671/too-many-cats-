extends Node
class_name States

# all possible character states
enum STATES{IDLE, RUNNING, DODGING}

@onready var player_state = STATES.IDLE
