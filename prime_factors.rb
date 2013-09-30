require 'prime'

# returns primes upto num
def eratosthenes_sieve(upto_num)
  primes = (2..upto_num).to_a
  
  primes.each do |n|
    
    # skip n if it has already been marked as composite
    next if n == 'x'
    
    # start with second multiple of n
    # (n has to be prime at this point)
    i = 2
    ith_multiple_of_n = n * i
    
    # loop through the multiples of n
    # within the range, and strike them out
    while ith_multiple_of_n <= upto_num
      
      # mark the multiple as non prime
      # remember primes starts at 2
      # 2, idx: 0
      # 3, idx: 1
      # 4: idx: 2
      primes[ith_multiple_of_n - 2] = 'x'
      
      # go to the next multiple of n
      i += 1
      ith_multiple_of_n = n * i
    end
    
  end
  
  # return all the primes (remove 'x's)
  return primes.reject { |e| e == 'x' }

end
  
def prime_divisors(num)
  return [num] if Prime.prime? num
  max_prime_divisor = Math.sqrt(num) + 1
  eratosthenes_sieve(max_prime_divisor).select { |p| num % p == 0 }
end

def prime_factors(num)
  prime_factors = []
  prime_divisors(num).each do |prime_divisor|
    until num % prime_divisor > 0
      prime_factors << prime_divisor
      num /= prime_divisor
    end
  end
  return prime_factors
end

p prime_divisors(3)         == [3]
p prime_divisors(6)         == [2,3]
p prime_divisors(8)         == [2]
p prime_divisors(25)        == [5]
 
p prime_factors(3)         == [3]
p prime_factors(6)         == [2,3]
p prime_factors(8)         == [2,2,2]
p prime_factors(25)        == [5,5]


# ASK: I don't know what's going on here.
# ok. i think sqrt fails on this.
# p prime_factors(123123123) == [3, 3, 41, 333667]
# p Prime.prime_division(123123123).inspect