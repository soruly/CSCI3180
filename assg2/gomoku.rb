# CSCI3180 Principles of Programming Languages
# -- Declaration ---
# I declare that the assignment here submitted 
# is original except for source material explicitly
# acknowledged. I also acknowledge that I am aware of
# University policy and regulations on honesty in 
# academic work, and of the disciplinary guidelines
# and procedures applicable to breaches of such policy
# and regulations, as contained in the website
# http://www.cuhk.edu.hk/policy/academichonesty/
# Assignment 2
# Name: 
# Student ID: 
# Email Addr: 
#
class Gomoku

    def initialize 
        @board = Array.new(15) { Array.new(15,".") }
        @player1 = nil
        @player2 = nil
        @turn = nil
    end

    def startGame
        begin
            print "First player is (1) Computer or (2) Human? "
            player_type = gets.chomp.to_i
            puts "Invalid input, please enter 1 or 2" unless player_type == 1 || player_type == 2
        end until player_type == 1 || player_type == 2

        if player_type == 1
            puts "Player O is Computer"
            @player1 = Computer.new('O')
        elsif player_type == 2
            puts "Player O is Human" 
            @player1 = Human.new('O')
        end


        begin
            print "Second player is (1) Computer or (2) Human? "
            player_type = gets.chomp.to_i
            puts "Invalid input, please enter 1 or 2" unless player_type == 1 || player_type == 2
        end until player_type == 1 || player_type == 2

        if player_type == 1
            puts "Player X is Computer"
            @player2 = Computer.new('X')
        elsif player_type == 2
            puts "Player X is Human" 
            @player2 = Human.new('X')
        end

        @turn = @player1

        begin
            printBoard
            
            #Let the player know what is on the board
            #The player should look for valid moves he/it is going to make
            @turn.look_at_the_board(@board)
            newMove = @turn.nextMove

            #players cannot put stones directly on board
            #the host (Game master) do that for players
            #use instance method get_symbol to obtain player's symbol
            @board[newMove[0]][newMove[1]] = @turn.get_symbol
            puts "Player #{@turn.get_symbol} places to row #{newMove[0]}, col #{newMove[1]}"

            #move the turn to another player
            @turn = @turn == @player1 ? @player2 : @player1

        end until some_player_wins || board_is_full

        printBoard

        puts "Draw game!" if board_is_full
        puts "Player #{some_player_wins} wins!" unless board_is_full

    end

    def some_player_wins
        won_player = nil
        board_pattern = Array.new

        #look at the board horizontally
        @board.each { |row| 
            board_pattern.push(row.join)
        }

        #look at the board vertically
        temp = Array.new(15) { Array.new(15,".") }
        for row_num in 0..14
            for col_num in 0..14
                temp[col_num][row_num] = @board[row_num][col_num]
            end
        end
        temp.each { |row| 
            board_pattern.push(row.join)
        }

        #lookat the board diagonally /
        temp = Array.new(29) { Array.new(29) }
        for row_num in 0..28
            row = row_num > 14 ? 14 : row_num
            col = row_num > 14 ? row_num - 14 : 0
            while col <= row_num && col <= 14
                temp[row_num] << @board[row][col]
                col += 1
                row -= 1
            end
        end
        temp.each { |row| 
            board_pattern.push(row.join)
        }

        #lookat the board diagonally \
        temp = Array.new(29) { Array.new(29) }
        for row_num in 0..28
            row = row_num <= 14 ? row_num : 14
            col = row_num <= 14 ? 14 : 28 - row_num
            while row >= 0 && col >= 0
                temp[row_num] << @board[row][col]
                col -= 1
                row -= 1
            end
        end
        temp.each { |row| 
            board_pattern.push(row.join)
        }

        #debug use
        #board_pattern.each { |line| 
        #    puts line
        #}

        #now check if there is any 5-in-a-row in any direction
        #conditionally assign the won_player
        board_pattern.each { |line| 
            won_player ||= "O" if line.include? "OOOOO"
            won_player ||= "X" if line.include? "XXXXX"
        }
        
        return won_player
    end

    #just count how many dots remain on board
    def board_is_full
        space_left = 0
        @board.each { |row| 
            space_left += row.count('.')   
        }
        return space_left <= 0
    end
    
    def printBoard
        row_num = 0
        print '                       1 1 1 1 1'
        puts
        print '   0 1 2 3 4 5 6 7 8 9 0 1 2 3 4'
        puts
        @board.each { |row| 
            print row_num.to_s.rjust(2) << ' '
            print row.join(' ')
            row_num += 1
            puts
        }
    end
end

class Player
    def initialize(symbol)
        @symbol = symbol
    end

    def nextMove
    end

    #this method would always be called before nextMove
    def look_at_the_board(board)
        @board = board
    end

    def get_symbol
        @symbol
    end

    def is_valid_move(position)
        if ( (position[0].is_a? Integer) == false || (position[1].is_a? Integer) == false )
            puts "Invalid input. Try again!"
            return false
        end 
        if ( position[0].between?(0,14) == false || position[1].between?(0,14) == false )
            puts "Position out of range. Try again!"
            return false
        end
        if @board[position[0]][position[1]] != '.'
            puts "This move has been taken already. Try another move!"
            return false
        end
        return true
    end
end


class Human < Player
    def nextMove
        begin
            print "Player #{@symbol}, make a move (row col):"
            position = gets.chomp.split.map{|i| i.to_i}
        end until is_valid_move(position)
        return position
    end
end

class Computer < Player
    def nextMove
        #look for all empty space on board
        available_positions = []
        for x in 0..14
            for y in 0..14
                available_positions.push([x,y]) if @board[x][y] == '.'
            end
        end

        #randomly select one of the empty space on board
        return available_positions.sample
    end
end

Gomoku.new.startGame