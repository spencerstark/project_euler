# This is a solution to https://projecteuler.net/problem=54  
# This program is simply for fun! 
# Contact me if there are questions or feedback w.s.stark@gmail.com
#
# MIT license: 
#
# Copyright (c) 11/05/2015 Spencer Stark 
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
# 

def total(cards)
	cards.map(&:to_i).reduce(:+)
end

def high_card_kicker(players_hand)
	first_players_cards = players_hand.split
	hashed_players_cards_array = Array.new
	first_players_cards_hash = Hash.new

	first_players_cards.map do |card|
			if card[0] == 'T' 
					card_value ='10'
				elsif card[0] == 'J'  
					card_value ='11'
				elsif card[0] == 'Q'  
					card_value ='12'
				elsif card[0] == 'K'  
					card_value ='13'
				elsif card[0] == 'A'
					card_value ='14'
				else 
					card_value = card[0] 
			end 
		first_players_cards_hash = {:value => card_value, :suit => card[1]}
		hashed_players_cards_array.push(first_players_cards_hash)
	end

	cards_array = Array.new
	hashed_players_cards_array.each do |parsed_cards|
		cards_array.push(parsed_cards[:value].to_i)
	end

	sorted_cards_array = cards_array.sort.reverse
	return high_card = sorted_cards_array[0]
end

def parse_the_players_hand(players_hand)

#---------------------------------------- 
# this should be a method because I'll need it later. 
#---------------------------------------- 
	first_players_cards = players_hand.split
	hashed_players_cards_array = Array.new
	first_players_cards_hash = Hash.new

	first_players_cards.map do |card|
			if card[0] == 'T' 
					card_value ='10'
				elsif card[0] == 'J'  
					card_value ='11'
				elsif card[0] == 'Q'  
					card_value ='12'
				elsif card[0] == 'K'  
					card_value ='13'
				elsif card[0] == 'A'
					card_value ='14'
				else 
					card_value = card[0] 
			end 
		first_players_cards_hash = {:value => card_value, :suit => card[1]}

		hashed_players_cards_array.push(first_players_cards_hash)
	end

#---------------------------------------- 
# I believe I have finally gotten data into a format I can use! 
#---------------------------------------- 
	total_hand_score = 0
#---------------------------------------- 
# Lets set total_hand_score
#---------------------------------------- 
	cards_array = Array.new

	hashed_players_cards_array.each do |parsed_cards|
		cards_array.push(parsed_cards[:value].to_i)
	end

	sorted_cards_array = cards_array.sort.reverse
#---------------------------------------- 
# We now have an array of values high to low. We can now grade them. 
# we can seperate cards into two groups now. 
#---------------------------------------- 

	if sorted_cards_array.length == sorted_cards_array.uniq.length
		# first group has all 5 cards unique. 
		# because of the linear fashion of this program, we must check flush before we check for a straight flush/royal flush. 
		# we need to do something about a normal flush.
		# flushes are weird. They're the only win condition that doesn't care about card value until you get to straights. 
		# beause of this we have to check EVERYTHING! a high card condition could also be a flush
		# same with 
		# Flush: All cards of the same suit.
		flush_suit_array = Array.new
		hashed_players_cards_array.each do |parsed_cards_for_suit|
			flush_suit_array.push(parsed_cards_for_suit[:suit])
		end
		if flush_suit_array.uniq.length == 1
			total_hand_score = 600 + total(sorted_cards_array)
		end

		# Straight: All cards are consecutive values. 
		if sorted_cards_array[1] == sorted_cards_array[0] - 1 and sorted_cards_array[2] == sorted_cards_array[1] - 1 and sorted_cards_array[3] == sorted_cards_array[2] - 1 and sorted_cards_array[4] == sorted_cards_array[3] - 1 
			# puts "It's a straight" 
			total_hand_score = 500 + total(sorted_cards_array)
		# Straight Flush: All cards are consecutive values of same suit. 
			suit_array = Array.new			
			hashed_players_cards_array.each do |parsed_cards_for_suit|
				suit_array.push(parsed_cards_for_suit[:suit])
			end

			if suit_array.uniq.length == 1
				total_hand_score = 900 + total(sorted_cards_array)

				if sorted_cards_array[0] == 14
		# Royal Flush: Ten, Jack, Queen, King, Ace, in same suit. 					
					total_hand_score = 1060 
				end
			end
		else
			# If we make it here, we need to figure out how to indicate just the highest card. 
		# High Card: Highest value card.
			total_hand_score = sorted_cards_array[0]
		end 
	else
		# second group has repeats. 
		grouped_cards_array = Array.new
		grouped_cards_array = sorted_cards_array.group_by{ |e| e }.select { |k, v| v.size > 1 }.map(&:first)
	
		if grouped_cards_array.count > 1

			# hmm, lets try just counting the first two parts of grouped_cards_array
			# if there are more than 2 values in grouped_cards_array we have a problem! 
			if grouped_cards_array[2].nil? 
				
				first_index_count = sorted_cards_array.count(grouped_cards_array[0])
				second_index_count = sorted_cards_array.count(grouped_cards_array[1])

				if first_index_count == second_index_count 	# Two Pairs: Two different pairs.
					total_hand_score = 300 #need to figure out who wins if there is a tie. 
				else 	# Full House: Three of a kind and a pair.
					total_hand_score = 700 #need to figure out who wins if there is a tie. 
				end
			end
		else
			i = 0
			sorted_cards_array.each do |cards|
				if cards == grouped_cards_array[0]
					i = i + 1 
				end  
			end  
		# Lets grade i now.
			case 
			when i == 2 # One Pair: Two cards of the same value.
				total_hand_score = 200 + grouped_cards_array[0]
			when i == 3 # Three of a Kind: Three cards of the same value.
				total_hand_score = 400 + grouped_cards_array[0]		
			when i == 4 # Four of a Kind: Four cards of the same value.
				total_hand_score = 800 + grouped_cards_array[0]
			else
				# puts "something went wrong with pairs"
			end
		end 
	end
	return total_hand_score
end

all_hands = File.readlines(Dir.pwd + "/p054_poker.txt")
# We need to set these so we can count them up later. 
	first_player_total_wins = 0
	second_player_total_wins = 0

all_hands.each { |both_players_hands|
	# quick and dirty way to get first part of hand from file. 
	first_players_hand = both_players_hands[0..14]
	first_player_score = parse_the_players_hand(first_players_hand)
# -----------------------------------------------------------
	# I need a line break to differentiate between player 1 and 2 on each loop.
	second_players_hand = both_players_hands[15..30]
	second_player_score = parse_the_players_hand(second_players_hand)
# -----------------------------------------------------------

	if first_player_score > second_player_score
		puts "player one wins!"
		first_player_total_wins = first_player_total_wins + 1

	elsif second_player_score > first_player_score
		puts "player two wins!"
		second_player_total_wins = second_player_total_wins + 1

	else first_player_score == second_player_score
		first_player_kicker = high_card_kicker(first_players_hand)
		second_player_kicker = high_card_kicker(second_players_hand)

		if first_player_kicker > second_player_kicker
			puts "player one wins!"
			first_player_total_wins = first_player_total_wins + 1

		elsif second_player_kicker > first_player_kicker
			puts "player two wins!"
			second_player_total_wins = second_player_total_wins + 1


		else second_player_kicker == first_player_kicker
				puts "dang, still tied. lets investigate!"
			puts first_players_hand
			puts second_players_hand
		end
	end
	puts "----------"
}

puts first_player_total_wins
puts second_player_total_wins
puts first_player_total_wins + second_player_total_wins