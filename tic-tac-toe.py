#  A simple Tic-Tac-Toe game
# Players 'X' and 'O' take turn inputing their position on the command line using numbers 1-9
# 1 | 2 | 3
# ---------
# 4 | 5 | 6
# ---------
# 7 | 8 | 9
#


# The Game Board 
board = {
    1: '1', 2: '2', 3: '3',
    4: '4', 5: '5', 6: '6',
    7: '7', 8: '8', 9: '9'
}

# TODO: update the gameboard with the user input
def markBoard(position, mark):
    if position in board:
        board[position] = mark


# TODO: print the game board as described at the top of this code skeleton
# Will not be tested in Part 1
def printBoard():
    print('\n')
    print(f"{board[1]} | {board[2]} | {board[3]}")
    print("---------")
    print(f"{board[4]} | {board[5]} | {board[6]}")
    print("---------")
    print(f"{board[7]} | {board[8]} | {board[9]}")



# TODO: check for wrong input, this function should return True or False.
# True denoting that the user input is correct
# you will need to check for wrong input (user is entering invalid position) or position is out of bound
# another case is that the position is already occupied
def validateMove(position):

    if position.isdigit(): 
        position = int(position)    

        if (position > 0) and (position < 10): 
            
            if (board[position]=='O') or (board[position]=='X'):
                print("Invalid move.")
                return False 
            else:
                return True 
        
        else:             
            print("Please enter a number between 1 to 9.")
            return False
        
    else:
        print("Please enter a number between 1 to 9.")
        return False

    
    
# TODO: list out all the combinations of winning, you will neeed this
# one of the winning combinations is already done for you
winCombinations = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9],
    [1, 4, 7],
    [2, 5, 8],
    [3, 6, 9],
    [1, 5, 9],
    [3, 5, 7],
]

# TODO: implement a logic to check if the previous winner just win
# This method should return with True or False
def checkWin(player):
    for combo in winCombinations:
        if board[combo[0]] == board[combo[1]] == board[combo[2]] == player:
            return True
    return False


# TODO: implement a function to check if the game board is already full
# For tic-tac-toe, tie bascially means the whole board is already occupied
# This function should return with boolean
def checkFull():
    for i in board:
        if (board[i]=='O') or (board[i]=='X'):
            continue
        else:
            return False
    
    return True


#########################################################
## Copy all your code/fucntions in Part 1 to above lines
## (Without Test Cases)
#########################################################



gameEnded = False
currentTurnPlayer = 'X'

# entry point of the whole program
print('Game started: \n\n' +
    ' 1 | 2 | 3 \n' +
    ' --------- \n' +
    ' 4 | 5 | 6 \n' +
    ' --------- \n' +
    ' 7 | 8 | 9 \n')

# TODO: Complete the game play logic below
# You could reference the following flow
# 1. Ask for user input and validate the input
# 2. Update the board
# 3. Check win or tie situation
# 4. Switch User

while True:

    while not gameEnded:
        printBoard()
        move = input(f"{currentTurnPlayer}'s turn, input: ")
  
        if validateMove(move):
            move = int(move)
            markBoard(move, currentTurnPlayer)
            
            if checkWin(currentTurnPlayer):
                printBoard()
                print(f"Player {currentTurnPlayer} wins!")
                gameEnded = True
            elif checkFull():
                printBoard()
                print("It's a tie!")
                gameEnded = True
            else:
                currentTurnPlayer = 'O' if currentTurnPlayer == 'X' else 'X'
        else:
            continue

    
    if gameEnded:
        replay = input("Do you want to play again? (yes/no): ").lower()
        if replay == 'yes':
            board = {
                        1: '1', 2: '2', 3: '3',
                        4: '4', 5: '5', 6: '6',
                        7: '7', 8: '8', 9: '9'
                    }
            gameEnded = False
            currentTurnPlayer = 'X'
        else:
            break



# Bonus Point: Implement the feature for the user to restart the game after a tie or game over
