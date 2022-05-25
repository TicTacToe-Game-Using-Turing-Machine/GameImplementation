using GameZero
using Colors


HEIGHT = 600
WIDTH = 600
BACKGROUND = colorant"#f7f7f7"

board = fill(0,3,3)    # 3x3 matrix of the game_ongoing of each tile
game_ongoing = true
i = 0

circle = Actor("circle.png")
cross = Actor("cross.png")


##############################################################################
##                  Turing Machine Alphabet and 4 Tapes                     ##
##############################################################################

# Finite set of Input alphabets, X is Player p’s Symbol and O is Player o’s Symbol
sigma = ['p','o',1,2,3,4,5,6,7,8,9]

# non-empty finite set of Tape Alphabets, C is Left end Marker and $ is Right End Marker
gamma = ['C','p','o',1,2,3,4,5,6,7,8,9,'b','X','O','$']

# Input tape is used to keep track of the remaining
# input that can be chosen by both players.
input_tape = ['C','p',1,2,3,4,5,6,7,8,9,'$']
input_tape_head = 1

# Player's tape is used to remember its covering slots on the board
# to check winning sequence by comparing with the sequences in winning_seq.
p_tape = ['C','b','b','b','b','b','$']
p_tape_head = 1

# Opponent's tape is used to remember its covering slots on the board
# to check winning sequence by comparing with the sequences in winning_seq.
o_tape = ['C','b','b','b','b','b','$']
o_tape_head = 1

# Winning Sequences.Contains 8 winning sequences for 3 by 3 Grid Tic tac toe that are separated by 'T'.
winning_seq = ['C','1','2','3','T','4','5','6','T','7','8','9','T','1','4','7','T','2','5','8','T','3','6','9','T','1','5','9','T','3','5','7','$']
winning_seq_head = 1

##############################################################################
##############################################################################

function player_state(move)

    turn = 'p'  # First player starts the game.

    global input_tape_head += 1
    input_tape[input_tape_head] = turn
    input_tape_head -= 1

    if p_tape[p_tape_head] == '$' # If you encounter right end marker than player cannot make a move anymore
        exit(0)
    end

    # First let the player select an input from the input tape.
    # move = 4    # Suppose player has chosen the the fourth grid to move.

    # as long as the head doesn't read the left limit character from the input tape, keep moving right and read the tape until you reach the symbol you want.
    while (input_tape[input_tape_head] != '$') && (input_tape[input_tape_head] != move)
        global input_tape_head += 1
    end

    if (input_tape[input_tape_head] == '$')
        println("DRAW!!!")
        exit()
    end

    # read the desired value from input tape.
    read_value = input_tape[input_tape_head]

    # After reading the move from the input tape, write blank character to the grid where we read from so that no one can read that same move again.
    input_tape[input_tape_head] = 'b'


    # Rewind back the input tape back to the start.
    while input_tape[input_tape_head] != 'C'
        global input_tape_head -= 1
    end

    # Now write the read value to the player's tape.
    while p_tape[p_tape_head] != 'b' && p_tape[p_tape_head] != '$'  # If the tape head points to left marker 'C' than move 1 step right to that tape.
        global p_tape_head += 1
    end

    # Read the player's move to its own tape so that we can write that position to winning_sequence tape to check if there is a winning later on.
    p_tape[p_tape_head] = Char(read_value+'0')
    # println(p_tape[p_tape_head] == Char(read_value+'0'))
    # println(p_tape)

    # Write the player's move to every winning sequence positions.
    while winning_seq[winning_seq_head] != '$'
        if winning_seq[winning_seq_head] == p_tape[p_tape_head]
            winning_seq[winning_seq_head] = 'X'
        end
        global winning_seq_head += 1
    end

    # Place back the winning sequence tape head to the start.
    while winning_seq[winning_seq_head] != 'C'
        global winning_seq_head -= 1
    end

    # Move the player's tape by one.
    # p_tape_head += 1


end

function win_player()


    # Now check the games condition (Player Win, Opponent Win or Draw).
    # winning_seq_head = 1
    while winning_seq[winning_seq_head] != '$'

        global winning_seq_head += 1

        if winning_seq[winning_seq_head] == 'T' || winning_seq[winning_seq_head] == '$'
            println("CONGRATULATIONS!!! YOU ARE A HERO :)")
            println(winning_seq)
            global game_ongoing = false
            return true
            # break
            # exit()
        end

        if winning_seq[winning_seq_head] != 'X'
            global winning_seq_head
            # If we encounter 'O' or 'b' on the tape, then jump to the next 'T' symbol to check the other winning condition.
            while winning_seq[winning_seq_head] != 'T' && winning_seq[winning_seq_head] != '$'
                global winning_seq_head += 1
            end
            if winning_seq[winning_seq_head] == '$'
                break
            end
            # winning_seq_head += 1
            # continue
        end
    end


    while winning_seq[winning_seq_head] != 'C'
        global winning_seq_head -= 1
    end

    println(winning_seq)
    return false
end

function opponent_state(move)

    turn = 'o'  # First player starts the game.

    global input_tape_head += 1
    input_tape[input_tape_head] = turn
    input_tape_head -= 1

    if o_tape[o_tape_head] == '$' # If you encounter right end marker than player cannot make a move anymore
        exit(0)
    end

    # First let the player select an input from the input tape.
    # move = 7    # Suppose player has chosen the the fourth grid to move.
    # as long as the head doesn't read the left limit character from the input tape, keep moving right and read the tape until you reach the symbol you want.
    while (input_tape[input_tape_head] != '$') && (input_tape[input_tape_head] != move)
        global input_tape_head += 1
    end

    if (input_tape[input_tape_head] == '$')

        println("DRAW!!!")
        println(input_tape)

        sleep(100)
    end

    # read the desired value from input tape.
    read_value = input_tape[input_tape_head]

    # After reading the move from the input tape, write blank character to the grid where we read from so that no one can read that same move again.
    input_tape[input_tape_head] = 'b'


    # Rewind back the input tape back to the start.
    while input_tape[input_tape_head] != 'C'
        global input_tape_head -= 1
    end

    # Now write the read value to the player's tape.
    while o_tape[o_tape_head] != 'b' && o_tape[o_tape_head] != '$'  # If the tape head points to left marker 'C' than move 1 step right to that tape.
        global o_tape_head += 1
    end

    # Read the player's move to its own tape so that we can write that position to winning_sequence tape to check if there is a winning later on.
    o_tape[o_tape_head] = Char(read_value+'0')
    # println(p_tape[p_tape_head] == Char(read_value+'0'))
    # println(p_tape)

    # Write the player's move to every winning sequence positions.
    while winning_seq[winning_seq_head] != '$'
        if winning_seq[winning_seq_head] == o_tape[o_tape_head]
            winning_seq[winning_seq_head] = 'O'
        end
        global winning_seq_head += 1
    end

    # Place back the winning sequence tape head to the start.
    while winning_seq[winning_seq_head] != 'C'
        global winning_seq_head -= 1
    end

    # Move the player's tape by one.
    # p_tape_head += 1


end

function win_opponent()
    # Now check the games condition (Player Win, Opponent Win or Draw).
    # winning_seq_head = 1
    while winning_seq[winning_seq_head] != '$'

        global winning_seq_head += 1

        if winning_seq[winning_seq_head] == 'T' || winning_seq[winning_seq_head] == '$'
            println("OPPONENT WIN!! FATALITY.")
            println(winning_seq)

            global game_ongoing = false
            return true
            # break
            # exit()
        end

        if winning_seq[winning_seq_head] != 'O'
            global winning_seq_head
            # If we encounter 'O' or 'b' on the tape, then jump to the next 'T' symbol to check the other winning condition.
            while winning_seq[winning_seq_head] != 'T' && winning_seq[winning_seq_head] != '$'
                global winning_seq_head += 1
            end
            if winning_seq[winning_seq_head] == '$'
                break
            end
            # winning_seq_head += 1
            # continue
        end
    end


    while winning_seq[winning_seq_head] != 'C'
        global winning_seq_head -= 1
    end

    
    return false;

end

function check_draw()

    global input_tape_head += 2
    while (input_tape[input_tape_head] != '$') && (input_tape[input_tape_head] == 'b')
        global input_tape_head += 1
    end

    if (input_tape[input_tape_head] == '$')
        println("DRAW!!!")
        return true
    end
    # Rewind back the input tape back to the start.
    while input_tape[input_tape_head] != 'C'
        global input_tape_head -= 1
    end

    return false

end

function convert_to_row_col(move)

    row = div(move,3)
    if move % 3 == 0
        row -= 1
    end
    row += 1

    col = move % 3
    if col == 0
        col = 3
    end

    return row, col

end

function convert_to_move(row, col)

    return (row-1)*3 + (col-1)%3 + 1

end



####################################################################
####################################################################
####################################################################

function draw()
    fill(colorant"#f7f7f7")
    draw(Line(200, 0, 200, 600), colorant"black")
    draw(Line(400, 0, 400, 600), colorant"black")
    draw(Line(0, 200, 600, 200), colorant"black")
    draw(Line(0, 400, 600, 400), colorant"black")
    for i in 1:3
        for j in 1:3
            if board[i, j] == 1
                cross.center = (200j - 100, 200i - 100)
                draw(cross)
            elseif board[i, j] == -1
                circle.center = (200j - 100, 200i - 100)
                draw(circle)
            end
        end
    end
end

function on_mouse_down(g,pos)
    if game_ongoing
        x = pos[1]
        y = pos[2]
        if x < 200
            j = 1
        elseif x < 400
            j = 2
        else
            j = 3
        end

        if y < 200
            i = 1
        elseif y < 400
            i = 2
        else
            i = 3
        end

        if board[i, j] == 0
            board[i,j] = 1

            move = convert_to_move(i,j)
            player_state(move)


            game_over()
            if game_ongoing
                random_ai()
                game_over()
            end
        else
            println("Invalid move")
            play_sound("eep.wav")
        end
    end
end


function update()


end

function game_over()
    
    # global winning_seq = ['C','1','2','3','T','4','5','6','T','7','8','9','T','1','4','7','T','2','5','8','T','3','6','9','T','1','5','9','T','O','O','O','$']
    # global winning_seq_head = 1
    # global winning_seq = ['C', 'X', 'O', 'X', 'T', 'X', 'O', 'O', 'T', 'O', 'X', 'X', 'T', 'X', 'X', 'O', 'T', 'O', 'O', 'X', 'T', 'X', 'O', 'X', 'T', 'X', 'O', 'X', 'T', 'X', 'O', 'O', '$']
    # global winning_seq_head = 1
    # global input_tape = ['C','p','b','b','b','b','b','b','b','b','b','$']
    # global input_tape_head = 1


    if win_player()
        println("PLAYER WINS!")
        global game_ongoing = false
    elseif win_opponent()
        println("CPU WINS!")
        global game_ongoing = false
    
    elseif check_draw()
        println("DRAW!")
        global game_ongoing = false
        return
    end

end

function random_ai()
    indices = findall(x -> x == 0, board)
    move = rand(indices)
    board[move] = -1

    row = move[1]
    col = move[2]
    move = convert_to_move(row, col)
    opponent_state(move)
end
