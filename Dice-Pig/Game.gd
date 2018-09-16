extends Node

var dice = 0 # 0 - 5
var turnPoints = 0 # 0 - 100
var player1Points = 0 # 0 - 100
var player2Points = 0 # 0 - 100
var currentPlayer = 0 # 0 - 1

const colorActive = Color("#ffffff")
const colorInactive = Color("#bbbbbb")

func _ready():
	randomize()

	resetTurnPoints()
	resetPlayerPoints()
	setCurrentPlayer(0)

func resetTurnPoints():
    turnPoints = 0
    $Turn/Points.text = str(0)

func resetPlayerPoints():
    player1Points = 0
    $Player1/Points.text = str(0)
    player2Points = 0
    $Player2/Points.text = str(0)

func setCurrentPlayer(player):
    currentPlayer = player
    if currentPlayer == 0:
        $Player1/Points.modulate = colorActive
        $Player2/Points.modulate = colorInactive
        $Turn/Left.modulate = colorActive
        $Turn/Left.disabled = false
        $Turn/Right.modulate = colorInactive
        $Turn/Right.disabled = true
    else:
        $Player1/Points.modulate = colorInactive
        $Player2/Points.modulate = colorActive
        $Turn/Left.modulate = colorInactive
        $Turn/Left.disabled = true
        $Turn/Right.modulate = colorActive
        $Turn/Right.disabled = false

func setNextPlayer():
    resetTurnPoints()
    if currentPlayer == 0:
        setCurrentPlayer(1)
    else:
        setCurrentPlayer(0)

func _on_DiceButton_pressed():
    dice = randi() % 6
    $Dice.frame = dice
    if dice == 0:
        $Sound/Pig.play() # <-- play pig sound
        setNextPlayer()
        return

    # play dice sounds:
    var diceType = randi() % 4
    if diceType == 0:
        $Sound/Dice1.play()
    if diceType == 1:
        $Sound/Dice2.play()
    if diceType == 2:
        $Sound/Dice3.play()
    if diceType == 3:
        $Sound/Dice4.play()	

    turnPoints += dice + 1
    $Turn/Points.text = str(turnPoints)

func _on_Left_pressed():
	if turnPoints == 0:
		return
    
	$Sound/Hold.play() # <-- play hold sound
        
	player1Points += turnPoints
	$Player1/Points.text = str(player1Points)

	if _check_For_Winner():
		_game_Over()
	else:
		setNextPlayer()

func _on_Right_pressed():
	if turnPoints == 0:
		return
        
	$Sound/Hold.play() # <-- play hold sound
        
	player2Points += turnPoints
	$Player2/Points.text = str(player2Points)
	
	if _check_For_Winner():
		_game_Over()
	else:
		setNextPlayer()

func _check_For_Winner():
	if currentPlayer == 0:
		if player1Points >= 100:
			$Player1/P1Winner.visible = true;
			return true
		else:
			return false
	else:
		if player2Points >= 100:
			$Player2/P2Winner.visible = true;
			return true
		else:
			return false

func _game_Over():
	$DiceButton.disabled = true
	$Player2/Points.modulate = colorInactive
	$Player1/Points.modulate = colorInactive
	$Turn/Right.modulate = colorInactive
	$Turn/Left.modulate = colorInactive
	$Turn/Right.disabled = true
	$Turn/Left.disabled = true