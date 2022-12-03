# Code:
# A = rock
# B = paper
# C = scissors
#
# X = rock
# Y = paper
# Z = scissors

# Points:
# Rock: 1
# Paper: 2
# Scissors: 3
# 
# Lose: 0
# Tie: 3
# Win: 6


def outcome_score(theirs, mine)
    return 3 if (theirs == 'A' && mine == 'X') || (theirs == 'B' && mine == 'Y') || (theirs == 'C' && mine == 'Z') # tie
    return 6 if (theirs == 'A' && mine == 'Y') || (theirs == 'B' && mine == 'Z') || (theirs == 'C' && mine == 'X') # win
    0 # lose
end

def my_score(mine)
    return 1 if mine == 'X' 
    return 2 if mine == 'Y' 
    return 3 if mine == 'Z' 
end

def game_score(theirs, mine)
    my_score(mine) + outcome_score(theirs, mine)
end

games = File.open("input.txt").readlines
# test
# games = File.open("test_input.txt").readlines

score = games.reduce(0) do |total_score, game|
    theirs, mine = game.split
    total_score + game_score(theirs, mine)
end

puts "ANSWER: #{score}"