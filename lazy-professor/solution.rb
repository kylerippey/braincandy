input = File.readlines("test.txt")

# Build an answer hash for each question of the format: 
# {"A"=>40, "B"=>53, "C"=>38, "D"=>31}
questions = []
input.each do |student|
  student.chomp.chars.each_with_index do |answer, index|
    questions[index] ||= {}
    questions[index][answer] ||= 0
    questions[index][answer] += 1
  end
end

# Find the most popular answer for each question
# (If multiple answers are tied for a given question, one will be chosen by Hash#invert)
key = questions.map {|answers| answers.invert[answers.values.max]}

puts key.join
