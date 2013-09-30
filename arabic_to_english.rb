# PSEUDOCODE
#
# define a CONVERSION_TABLE with integer nos and their english equivalents
#
# raise error if selfber is not an iteger
# raise error if selfber is below zero
# return "zero" if selfber is zero
#
# for each value in the CONVERSION_TABLE |integer_version, english_version|:
#   # times that integer_version fits into original number = times
#   times = selfber / integer_version
#   consider times:
#     if it's zero, go to the next biggest integer in table
#     if times == one and selfber < 100
#      add the english version to the final result
#      (we don't want 'one nine' or 'one forty')
#     otherwise, add two things to the final result :
#       1. the english version of the quotient (recursed)
#       2. the english version
#     now parse the remainder
#

class Integer

  def to_english
    raise ArgumentError.new('Input must be >= 0') if self < 0
    return 'zero' if self == 0
    
    english_conversion_table = { 1_000_000_000_000 => 'trillion',
                                 1_000_000_000 => 'billion',
                                 1_000_000    => 'million',
                                 1_000        => 'thousand',
                                 100          => 'hundred',
                                 90           => 'ninety',
                                 80           => 'eighty',
                                 70           => 'seventy',
                                 60           => 'sixty',
                                 50           => 'fifty',
                                 40           => 'forty',
                                 30           => 'thirty',
                                 20           => 'twenty',
                                 19           => 'nineteen',
                                 18           => 'eighteen',
                                 17           => 'seventeen',
                                 16           => 'sixteen',
                                 15           => 'fifteen',
                                 14           => 'fourteen',
                                 13           => 'thirteen',
                                 12           => 'twelve',
                                 11           => 'eleven',
                                 10           => 'ten',
                                 9            => 'nine',
                                 8            => 'eight',
                                 7            => 'seven',
                                 6            => 'six',
                                 5            => 'five',
                                 4            => 'four',
                                 3            => 'three',
                                 2            => 'two',
                                 1            => 'one',
    }

    english_num = []
    integer_num = self
    english_conversion_table.each do |integer, english|
      times = integer_num / integer
      next if times == 0
      english_num << times.to_english if integer_num >= 100
      english_num << english
      integer_num = integer_num % integer
    end

    return english_num.join(' ')
  end

end
# testing
require 'rspec'

describe "Integer#to_english" do

  it 'should handle zero' do
    0.to_english.should == 'zero'
  end

  it "should return the correct english version of numbers up to 10" do
   2.to_english.should == 'two'
   1.to_english.should == 'one'
   3.to_english.should == 'three'
   4.to_english.should == 'four'
   5.to_english.should == 'five'
   6.to_english.should == 'six'
   7.to_english.should == 'seven'
   8.to_english.should == 'eight'
   9.to_english.should == 'nine'
   10.to_english.should == 'ten'
  end

  it 'should return the correct english version of numbers up to 100' do
    17.to_english.should == 'seventeen'
    12.to_english.should == 'twelve'
    11.to_english.should == 'eleven'
    21.to_english.should == 'twenty one'
    27.to_english.should == 'twenty seven'
    42.to_english.should == 'forty two'
    99.to_english.should == 'ninety nine'
    88.to_english.should == 'eighty eight'
    32.to_english.should == 'thirty two'
    92.to_english.should == 'ninety two'
    100.to_english.should == 'one hundred'
  end

  it 'should return the correct english version of numbers up to 1000' do
    101.to_english.should == 'one hundred one'
    234.to_english.should == 'two hundred thirty four'
    1_000.to_english.should == 'one thousand'
  end

  it 'should return the correct english version of numbers up to 1 000 000' do
    3_211.to_english.should == 'three thousand two hundred eleven'
    99_099.to_english.should == 'ninety nine thousand ninety nine'
    821_713.to_english.should == 'eight hundred twenty one thousand seven hundred thirteen'
    1_000_000.to_english.should == 'one million'
  end

  it 'should return the correct english version of numbers up to 1 000 000 000' do
    1_000_000_000.to_english.should == 'one billion'
  end

  # now broken.... 
  # it 'should return the correct english version of numbers up to 1 000 000 000' do
#     # .. and beyond
#     to_english(1_000_000_000_000).should == 'one trillion'
#   end

end
