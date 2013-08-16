# define prisoner class with random hat colour on initialization
class Prisoner
  attr_accessor :hat_colour, :alive_or_dead, :visible_red_hats, :array_position, :shout_out, :total_reds_known_about

  def initialize
    rand(2) > 0 ? (@hat_colour = "red") : (@hat_colour = "blue")
    @alive_or_dead = "alive"
    @visible_red_hats = nil
    @total_reds_known_about
    @shout_out
  end

# define instance method for each prisoner, except the first,  to call out his hat colour based on
#  responses so far and what he can see.
# all prisoners can hear the responses given behind them and use that, along with the number of red hats in front of them
# to figure out if the total number of red hats accounted for is odd or even.
  def call_own_hat_colour(first_response, other_responses)
    self.total_reds_known_about = (other_responses.count{|response| response == 'red'}) + self.visible_red_hats

    case first_response
    when 'red'
      self.total_reds_known_about % 2 == 0 ? (response = "red") : (response = "blue")
    when 'blue'
      self.total_reds_known_about % 2 == 0 ? (response = "blue") : (response = "red")
    end

    other_responses << response
    self.shout_out = response
    self.alive_or_dead = "dead" unless (self.shout_out == self.hat_colour)
  end
end


# line the prisoners up
prisoners_array = []
(0..99).each {|i| prisoners_array[i] = Prisoner.new}

#the start of the array is the back of the line, so each prisoner can see the hats of those prisoners ahead of him.
# assign visible red hats to each prisoner
prisoners_array.each_index do |i|
  visible_prisoners = prisoners_array.slice((i +1)..(prisoners_array.length-1))
  prisoners_array[i].visible_red_hats = visible_prisoners.select{|prisoner| prisoner.hat_colour == "red"}.count
end

# prisoners_array[0] has agreed to call out "red" if he sees an ODD number of red hats in front of him.
# first prisoner shouts out according to the agreement
prisoners_array[0].visible_red_hats % 2 == 0 ? (prisoners_array[0].shout_out = "blue") : (prisoners_array[0].shout_out = "red")

# his response determines whether he lives or dies. He only ever had a 50:50 chace
prisoners_array[0].alive_or_dead = 'dead' unless (prisoners_array[0].shout_out == prisoners_array[0].hat_colour)

# Now let's get responses from the rest of the prisoners....
array_of_responses = []
remaining_prisoners = prisoners_array.slice(1..(prisoners_array.length - 1))

remaining_prisoners.each do |prisoner|
  prisoner.call_own_hat_colour(prisoners_array[0].shout_out, array_of_responses)
end

total_reds = prisoners_array.count{|prisoner| prisoner.hat_colour == 'red'}
total_blues = prisoners_array.count{|prisoner| prisoner.hat_colour == 'blue'}
survivors = prisoners_array.count{|prisoner| prisoner.alive_or_dead == 'alive'}

puts "Total number of prisoners: #{prisoners_array.count}"
puts "FYI: #{total_reds} prisoners have red hats and #{total_blues} have blue hats"
puts "Survivors: #{survivors}"