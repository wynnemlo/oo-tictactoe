# tictactoe.rb
# An OOP command line tic-tac-toe program where the human plays against
# a computer that generates random moves.


# a 3 x 3 board that starts out empty and is filled up turn by turn
# by the human and computer with the markers "X" and "O".
class Board
	WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 5, 9], [3, 5, 7], [1, 4, 7], [2, 5, 8], [3, 6, 9]]

	attr_accessor :data

	def initialize
		@data = {}
		(1..9).each { |pos| @data[pos] = Square.new(" ") }
	end

	# Gives a visual presentation of the board.
	def draw
		system "clear"
		puts "     |     |     "
		puts "  #{data[1]}  |  #{data[2]}  |  #{data[3]} "
		puts "     |     |     "
		puts "-----+-----+-----"
		puts "  #{data[4]}  |  #{data[5]}  |  #{data[6]} "
		puts "     |     |     "
		puts "-----+-----+-----"
		puts "     |     |     "
		puts "  #{data[7]}  |  #{data[8]}  |  #{data[9]} "
		puts "     |     |     "
	end

	# Returns an array of empty positions.
	def empty_positions
		data.select { |_, square| square.value == " " }.keys
	end

	# Returns true if there are no more empty squares
	def all_squares_filled?
		empty_positions.size == 0
	end

	# Given a position and marker, adds the mark to the board.
	def mark_board(position, marker)
		data[position].mark(marker)
	end
end

class Player
	attr_reader :name, :marker

	def initialize(name, marker)
		@name = name
		@marker = marker
	end
end

class Square
	attr_accessor :value

	def initialize(value)
		@value = value
	end

	# Marks itself with the given marker.
	def mark(marker)
		self.value = marker
	end

	def to_s
		self.value
	end
end

class Game
	attr_accessor :board, :current_player

	def initialize
		@board = Board.new
		@board.draw
		@human = Player.new("Human", "X")
		@computer = Player.new("Computer", "O")
		@current_player = @human
	end

	# Gives the turn to the other player.
	def alternate_player
		if self.current_player == @human
			self.current_player = @computer
		else
			self.current_player = @human
		end
	end

	# Returns true if a winner is found.
	def found_winner?
		mark = self.current_player.marker
		Board::WINNING_LINES.each do |line|
			return true if @board.data[line[0]].value == mark && @board.data[line[1]].value == mark && @board.data[line[2]].value == mark
		end
		false
	end

	# Starts the game.
	def play
		loop do
			# Asks player for their move.
			# If it's a human player, ask for user input.
			if current_player == @human
				begin
					puts ("Choose a position (from 1 to 9) to place a piece:")
					pos = gets.chomp.to_i
				end until self.board.empty_positions.include?(pos)
			# If it's the computer, randomly pick an empty square.
			else
				pos = self.board.empty_positions.sample
			end
			# Marks the board with the player's move. Redraws the board.
			self.board.mark_board(pos, self.current_player.marker)
			self.board.draw
			# Announces winner if there is a winner
			if found_winner?
				puts "#{self.current_player.name} has won!"
				break
			# Ends game if there is a tie.
			elsif self.board.all_squares_filled?
				puts "It's a tie!"
				break
			# Else, it's the other player's turn.
			else
				alternate_player
			end
		end 
	end
end

game = Game.new.play
