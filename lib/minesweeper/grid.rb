require 'matrix'
module Minesweeper
  class Grid
    attr_reader :matrix

    def initialize(n, mines)
      @rows = n
      initialize_matrix(n)
      place_mines(n, mines)
      render_consealed
    end

    def choose(i, j)
      if @matrix[i][j].armed?
        render
        print_mine_hit
        true
      else
        @matrix[i][j] = Block.new Block.visited_block
        render_consealed
        ended?
      end
    end

    def ended?
      if !@matrix.flatten.uniq.join('').include? Block.armed_block
        print_game_won
        true
      else
        false
      end
    end

    private

    def break_line
      print "\n"
    end

    def initialize_matrix(n)
      @matrix = Array.new(n) { Array.new(n, Block.new) }
    end

    def place_mines(n, mines)
      while mines > 0
        i = (0..(n - 1)).to_a.sample
        j = (0...(n - 1)).to_a.sample
        next unless @matrix[i][j].to_s == Block.safe_block
        @matrix[i][j] = Block.new Block.armed_block
        mines -= 1
      end
    end

    def print_game_won
      puts 'Game over. You won!'
    end

    def print_mine_hit
      puts 'You hit a mine. Game over!'
    end

    def render
      matrix.each do |row|
        row.each do |col|
          print col
        end
        break_line
      end
      break_line
    end

    def render_consealed
      print ' '
      (0..(@rows - 1)).to_a.each do |n|
        print " #{n} "
      end
      break_line
      matrix.each_with_index do |row, i|
        print i
        row.each do |col|
          print col.to_s == Block.armed_block ? Block.safe_block : col
        end
        break_line
      end
      break_line
    end
  end
end
