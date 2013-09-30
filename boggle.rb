require 'pry'

class BoggleBoard

  DICE = %w(AAEEGN ELRTTY AOOTTW ABBJOO EHRTVW CIMOTU DISTTY EIOSST DELRVY ACHOPS HIMNQU EEINSU EEGHNW AFFKPS HLNNRZ DEILRX)

  def initialize
    @dice = []
    DICE.each do |die|
      @dice << BoggleDie.new(die)
    end
  end

  def shake!
    @dice.each { |die| die.roll! }
  end

  def each_die
    (0..15).each { |die_idx| yield die_idx }
  end

  def to_s
    str = ''
    dice_sides_up.map { |die| die == 'Q' ? 'Qu' : die }.each_slice(4) do |row|
      str += row.join("\t") + "\n"
    end
    return str
  end

  private

  def dice_sides_up
    @dice.map(&:side_up)
  end

end

class SmartBoggleBoard < BoggleBoard

  def include?(word)

    # All Qs are 'Qu' in boggle
    # also ignore case
    word = word.upcase.gsub('QU', 'Q')

    # find the indices of all the dice that show the first
    # letter of word
    starting_die_idxs = dice_sides_up.all_indices(word[0])

    case starting_die_idxs.size

    when 0

      # the first letter of the word is nowhere on the board
      # so the word is not there
      return false

    else

      # go through each of the dice that contain
      # the first letter of word
      starting_die_idxs.each do |starting_die_idx|
        # return true if you can find a word
        return true if find_word_with_starting_die_idx(word, starting_die_idx)
      end

      # .. none of the starting_die_idxs returned true.. so
      # the word is not there
      return false

    end

  end

  def each_adjacent_die_of(current_die_idx)
    each_die do |die_idx|
      yield(die_idx) if adjacent_dice(current_die_idx).include? die_idx
    end
  end

  private

  def find_word_with_starting_die_idx(word, starting_die_idx, visited_idxs = [])

    if visited_idxs.include? starting_die_idx

      # the initial index has been visited
      # so return false
      return false

    else

      case word.length
      when 1

        # base case:
        # the word is one character
        # only need to check the current cell

        if dice_sides_up[starting_die_idx] == word
          return true
        else
          return false
        end

      else

        # check whether the die matches the beginning of the word or not
        die_matches_beginning_of_word = (word[0] == dice_sides_up[starting_die_idx])
        # return false if the first letter of word is not shown in the current dice
        return false unless die_matches_beginning_of_word

        # otherwise
        # mark the cell as visited
        visited_idxs << starting_die_idx

        # go through every adjacent dice, to look for the rest of the word
        each_adjacent_die_of(starting_die_idx) do |adjacent_die_idx|

          # skip adjacent die if it was already visited
          next if visited_idxs.include? adjacent_die_idx

          # if one of the unvisited dice leads to a chain containing the word, the word is there
          return true if find_word_with_starting_die_idx(word[1..-1], adjacent_die_idx, visited_idxs)

        end

        # none of the adjacent dice has the rest of the word
        # so the word is not there
        return false

      end

    end

  end

  # returns the indices of the dice adjacent to current_dice_idx
  def adjacent_dice(current_die_idx)
    adjacent_dice_idx = [-5, -1, -4, -3, 1, 3, 4, 5]
    adjacent_dice_idx.map! { |idx_offset| current_die_idx + idx_offset }
    return adjacent_dice_idx - out_of_board_dice(current_die_idx)
  end

  def out_of_board_dice(current_die_idx)

    out_of_board_dice_idx = []

    # current cell (at current_die_idx) is on the leftmost column
    out_of_board_dice_idx += [-5, -1, 3] if current_die_idx % 4 == 0
    # current cell (at current_die_idx) is at topmost row
    out_of_board_dice_idx += [-5, -4, -3] if current_die_idx <= 3
    # current cell (at current_die_idx) is at righmost column
    out_of_board_dice_idx += [-3, 1, 5] if (current_die_idx + 1) % 4 == 0
    # current cell (at current_die_idx) is in bottom row
    out_of_board_dice_idx += [3, 4, 5] if current_die_idx >= 12

    return out_of_board_dice_idx.uniq.map { |idx_offset| current_die_idx + idx_offset }

  end

end

class BoggleDie

  attr_reader :side_up, :sides

  def initialize(sides)
    @sides = sides.split('')
    roll!
  end

  def roll!
    @side_up = @sides.sample
  end

  def to_s
    @side_up.to_s.sub 'Q', 'Qu'
  end

end

class Array

  def all_indices(match)
    self.each_index.select { |idx| self[idx] == match }
  end

end

#binding.pry


# testing
require 'rspec'


describe 'BoggleDie' do

  before(:each) do
    @d = BoggleDie.new('DEILRX')
  end

  describe 'BoggleDie#new' do

    it 'should have a side up' do
      ['D', 'E', 'I', 'L', 'R', 'X'].should include(@d.side_up)
    end

  end

end

describe 'SmartBoggleBoard' do

  before(:each) do
    @b = SmartBoggleBoard.new
  end

  describe '#include?' do

    before(:each) do
      # stub out the board...
      # A	T	W	B
      # E	O	S	E
      # R	A	N	U
      # H	P	L	L
      @b.stub(:dice_sides_up) { ["A", "T", "W", "B", "E", "O", "S", "E", "R", "A", "N", "U", "H", "P", "L", "L"] }
    end

    it 'should return true if a word is in the board' do
      @b.include?('HANLLUES').should be_true
      @b.include?('ATWBESN').should be_true
      @b.include?('RHAP').should be_true
      @b.include?('HROSEUL').should be_true
      @b.include?('ROSEUNA').should be_true
    end

    it 'should return false if a word is not in the board' do
      @b.include?('HNLLUES').should be_false
      @b.include?('ATWBESW').should be_false
      @b.include?('RAML').should be_false
      @b.include?('APPLE').should be_false
    end

    it 'should handle "Qu" correctly' do
      # board stub
      # E	L	T	 O
      # T	T	T	 E
      # Y	H	Qu U
      # E	K	Z	 R
      @b.stub(:dice_sides_up) { ["E", "L", "T", "O", "T", "T", "T", "E", "Y", "H", "Q", "U", "E", "K", "Z", "R"] }
      @b.include?('QUTT').should be_true
      @b.include?('QUUEOTL').should be_true
      @b.include?('ZQUTTHK').should be_true
    end

  end

  describe '#adjacent_dice' do

    it 'should be able to find the indices of the adjacent dice (given an index)' do @b.send(:adjacent_dice, 5).sort.should == [0, 1, 2, 4, 6, 8, 9, 10].sort
      @b.send(:adjacent_dice, 10).sort.should == [5, 6, 7, 9, 11, 13, 14, 15].sort
    end

    it 'should be able to skip over indices that are out of the grid' do
      @b.send(:adjacent_dice, 0).sort.should == [1, 4, 5].sort
      @b.send(:adjacent_dice, 3).sort.should == [2, 6, 7].sort
      @b.send(:adjacent_dice, 8).sort.should == [4, 5, 9, 12, 13].sort
      @b.send(:adjacent_dice, 15).sort.should == [10, 11, 14].sort
      @b.send(:adjacent_dice, 13).sort.should == [8, 9, 10, 12, 14].sort
      @b.send(:adjacent_dice, 7).sort.should == [2, 3, 6, 10, 11].sort
      @b.send(:adjacent_dice, 2).sort.should == [1, 3, 5, 6, 7].sort
    end

  end

  describe '#out_of_board_dice' do

    it 'should return the indices of dice out of grid' do
      @b.send(:out_of_board_dice, 0).sort.should == [-5, -4, -3, -1, 3].sort
      @b.send(:out_of_board_dice, 15).sort.should == [12, 16, 18, 19, 20].sort
      @b.send(:out_of_board_dice, 8).sort.should == [3, 7, 11].sort
      @b.send(:out_of_board_dice, 7).sort.should == [4, 8, 12].sort
      @b.send(:out_of_board_dice, 13).sort.should == [16, 17, 18].sort
      @b.send(:out_of_board_dice, 2).sort.should == [-3, -2, -1].sort
    end

  end

end

describe 'Array#all_indices' do

  it 'should return the indices of all the occurrences of character' do
    'apple'.split('').all_indices('p').should == [1, 2]
    'orange'.split('').all_indices('o').should == [0]
    'mango'.split('').all_indices('g').should == [3]
    'orango tango'.split('').all_indices('o').should == [0, 5, 11]
  end

  it 'should return an empty array if there are no matches' do
    'apple'.split('').all_indices('x').should == []
    'foobar'.split('').all_indices('1').should == []
  end

end
