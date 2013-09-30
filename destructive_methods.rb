def destroy_message!(message)
  if message.include?(':')
    message.replace(message.split(':').first + ':')
  else
    message
  end
end

def destroy_message(message)
  destroy_message!(message.dup)
end

# Non-Destructive method
original_message = "mr billy jones:fooo"
message = original_message.dup
p destroy_message(message) == "mr billy jones:"
p message == original_message

original_message = "mr billy jones"
message = original_message.dup
p destroy_message(message) == "mr billy jones"
p message == original_message

# Destructive Method
original_message = "mr billy jones:fooo"
message = original_message.dup
p destroy_message!(message) == "mr billy jones:"
p message != original_message

original_message = "mr billy jones"
message = original_message.dup
p destroy_message!(message) == "mr billy jones"

# Driver code... 
string = "this message will self-destruct: you can't hug every cat"
original_string = string.dup
puts destroy_message(string) == "this message will self-destruct:"
puts string == original_string # we shouldn't modify the string passed to destroy_message

string = "this has no message"
original_string = string.dup
puts destroy_message(string) == string
puts string == original_string # we shouldn't modify the string passed to destroy_message

string = "this message will self-destruct: you can't hug every cat"
original_string = string.dup
destroy_message!(string)
puts string == "this message will self-destruct:"
puts string != original_string

string = "this has no message"
result = destroy_message!(string)
puts result.nil?
puts string == string