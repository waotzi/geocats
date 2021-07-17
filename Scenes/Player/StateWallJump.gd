extends BasePlayerState

export var jump_height : float = 1000

func enter_logic(player: KinematicBody2D):
	.enter_logic(player)
	player.jump(jump_height)

func logic(player: KinematicBody2D, delta: float):

	if player.on_ladder and player.vertical != 0:
		return "climb"
	if player.underwater:
		return "swim"
	if player.grounded:
		#if you hit a ceiling
		return "idle" #start falling	

	if player.vy < 0:
		if player.isJumpPressed && !player.isDoubleJumped:
			return "double_jump" #set state to double jump

	else:
		return "fall"
	
	return null

func exit_logic(player: KinematicBody2D):
	.exit_logic(player)

