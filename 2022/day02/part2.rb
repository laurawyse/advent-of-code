# Code:
# A = rock
# B = paper
# C = scissors
#
# X = should lose
# Y = should tie
# Z = should win

# Points:
# Rock: 1
# Paper: 2
# Scissors: 3
# 
# Lose: 0
# Tie: 3
# Win: 6


def outcome_score(outcome)
    return 0 if outcome == 'X' # lose
    return 3 if outcome == 'Y' # tie
    return 6 if outcome == 'Z' # win
end

def my_score(mine)
    return 1 if mine == 'A'
    return 2 if mine == 'B'
    return 3 if mine == 'C'
end

def my_play(theirs, outcome)
    return theirs if outcome == 'Y' # tie
    if outcome == 'Z' # win
        return 'B' if theirs == 'A'
        return 'C' if theirs == 'B'
        return 'A' if theirs == 'C'
    else # lose (Y)
        return 'C' if theirs == 'A'
        return 'A' if theirs == 'B'
        return 'B' if theirs == 'C'
    end
end

def game_score(theirs, outcome)
    my_score(my_play(theirs, outcome)) + outcome_score(outcome)
end

games = File.open("input.txt").readlines
# test
# games = File.open("test_input.txt").readlines

score = games.reduce(0) do |total_score, game|
    theirs, outcome = game.split
    total_score + game_score(theirs, outcome)
end

puts "ANSWER: #{score}"