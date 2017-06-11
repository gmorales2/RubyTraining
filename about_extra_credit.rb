# EXTRA CREDIT:
#
# Create a program that will play the Greed Game.
# Rules for the game are in GREED_RULES.TXT.
#
# You already have a DiceSet class and score function you can use.
# Write a player class and a Game class to complete the project.  This
# is a free form assignment, so approach it however you desire.

# Include classes to use
require_relative 'about_dice_project'
require_relative 'scoring'

# This is the section for Modules
# DataPlayerRS Module: Data Player Sender/Receiver
module DataPlayerRS

  def create_players
    puts "How many players want to play the Dice Game?"
    print ">>> "
    number_of_players = gets.to_i
    players = Array.new

    case number_of_players
      when 2..10
        number_of_players.times do |i|
          print "Please write a name for player#{i+1}: "
          player_name = gets
          players << Player.new(player_name)
        end
      else
        raise GameError, "Your players can't be less than 2 or more than 10 "
    end
    return players
  end

  def specific_player_data(player)
    puts "Player name: #{player.name} :: Score: #{player.score}"
  end
end

# Player Class
class Player
  attr_accessor :name
  attr_accessor :score
  attr_accessor :enable

  def initialize(name)
    @name = name
    @score = 0
    @enable = false
  end
end

# Game Class
class Game
  include DataPlayerRS
  attr_reader :players

  def initialize
    @players = create_players
  end

  def greet
    puts "** Welcome to the Dice Game **"
  end

  def start_game
    next_round_players = []
    first_round(next_round_players)
  end

  def first_round(next_round_players)
    flag = false
    loop do
      @players.each do |player|
        print "- Player turn: #{player.name}" + "
        Do you want to roll the dice? Yes = 1 /No = 0 >>"
        response = gets.to_i
        if response == 1
          obtained_points, no_scoring_dice = score_roll(5)
          print "Points obtained #{obtained_points} \n"
          if obtained_points == 0
            player.score = 0
          else
            if ! player.enable
              if obtained_points >= 300
                player.score += obtained_points
                player.enable = true
              end
            else
              second_round(player, obtained_points, no_scoring_dice)
            end
          end
        end
        print "Your points are: #{player.score} \n"
        if player.score >= 3000
          flag = true
        end
      end
      break if flag
    end
    final_score
  end

 def final_score
    winner = String.new
    @players.each do |player|
      print "- Player turn: #{player.name}" + "
      Do you want to roll the dice for last time Yes = 1 /No = 0 >>"
      response = gets.to_i
      if response == 1
        obtained_points, no_scoring_dice = score_roll(5)
        if (no_scoring_dice > 0)
          second_round(player, obtained_points, no_scoring_dice)
        end
      end
      print "#{player.name} This is your score #{player.score} /n"
    end
  end

  def score_roll(roll_times)
    dice = DiceSet.new
    dice.roll(roll_times)
    points = score(dice.values)
    return points
  end

  def second_round(player, obtained_points, no_scoring_dice)
    player.score += obtained_points
    if no_scoring_dice >= 1
      print "Do you want to roll the dice again? Yes = 1 /No = 0 >>"
      response = gets.to_i
      if response == 1
        points, = score_roll(no_scoring_dice)
        if points != 0
          player.score += points
        else
          print "You lose all of your points. \n"
          player.score = 0
        end
      end
    end
  end
end

# Game Error Handling
class GameError < StandardError
end

dice_game = Game.new
dice_game.start_game
