class TicTacToe

  attr_reader :board

  def initialize(starting_player = 'x')
    contents = contents(starting_player)
    @board = Array.new(3) { contents.shift(3) }
  end

  private

  def contents(starting_player = 'x')
    players = ['x', 'o']
    other_player = players.reject { |p| p == starting_player }.first
    contents = Array.new(5, starting_player) + Array.new(4, other_player)
    return contents.shuffle
  end

end

# testing
require 'rspec'

describe 'TicTacToe' do

  describe '#new' do

    # REFACTOR: split this up into more tests
    it 'should make things that look like TicTacToe boards' do

      players = ['x', 'o']
      50.times do
        starting_player = players.sample
        other_player = players.reject { |p| p == starting_player }.first

        ttt = TicTacToe.new(starting_player)

        # rows and columns
        ttt.board.length.should == 3
        ttt.board.each do |row|
          row.length.should == 3
        end

        ttt.board.flatten.select { |p| p == starting_player }.should == Array.new(5, starting_player)
        ttt.board.flatten.select { |p| p == other_player }.should == Array.new(4, other_player)
      end

    end

  end

  describe '#contents' do

    it 'should generate an array with 5 x and 4 o by default' do
      ttt = TicTacToe.new.contents
      ttt.select { |e| e == 'x'}.should == Array.new(5, 'x')
      ttt.select { |e| e == 'o'}.should == Array.new(4, 'o')

    end

    it 'should generate an array with 5 starting player signs and 4 other players marks' do
      ttt_x = TicTacToe.new.contents('x')
      ttt_x.select { |e| e == 'x'}.should == Array.new(5, 'x')
      ttt_x.select { |e| e == 'o'}.should == Array.new(4, 'o')
      ttt_o = TicTacToe.new.contents('o')
      ttt_o.select { |e| e == 'o'}.should == Array.new(5, 'o')
      ttt_o.select { |e| e == 'x'}.should == Array.new(4, 'x')
    end

  end

end

