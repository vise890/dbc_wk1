def n_bottles_of_beer(n)

  if n == 1
    puts "1 bottle of beer on the wall, 1 bottle of beeer."
    puts "Take one down, pass it around, no more bottles of beer on the wall!"
  else
    puts "#{bottles_of_beer(n)} on the wall, #{bottles_of_beer(n)} bottles of beer."
    puts "Take one down, pass it around, #{bottles_of_beer(n-1)} of beer on the wall."
    puts
    n_bottles_of_beer(n-1)
  end

end

def bottles_of_beer(n)
  if n == 0
    "no more bottles of beer"
  elsif n == 1
    "1 bottle of beer"
  else
    "#{n} bottles of beer"
  end
end

n_bottles_of_beer(99)
