class Array
  
  def binary_search(object)
    
    low = 0
    high = self.length - 1

    while low <= high
      
      mid = ((low + high) / 2).floor
     
      if self[mid] < object
        # search the upper half
        # (exclude mid)
        low = mid + 1
      elsif self[mid] > object
        # search the lower half
        # (exclude mid)
        high = mid - 1
      else
        # match found
        # return mid index
        return mid
      end
    
    end

    # match not found
    return -1

  end

end

puts [1,2,3].binary_search(1) == 0
puts [1,2].binary_search(1) == 0
puts [1,2].binary_search(40) == -1
puts (100..200).to_a.binary_search(135) == 35 
puts [13,19,24,29,32,37,43].binary_search(35) == -1
puts [13,19,24,29,32,37,43].binary_search(43) == 6
