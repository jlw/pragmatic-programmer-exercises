#!/usr/bin/env ruby

require 'byebug'
require 'minitest'
require 'treetop'
Treetop.load 'my_time'

module MyTime
  class Integer < Treetop::Runtime::SyntaxNode
     def eval
       return self.text_value.to_i
     end
   end
end

class MyTimeParserTest < MiniTest::Test
  def test_hour_pm
    result = MyTimeParser.new.parse('4pm').eval
    assert_equal 960, result
  end

  def test_hour_minute_pm
    result = MyTimeParser.new.parse('7:38pm').eval
    assert_equal 1_178, result
  end

  def test_twenty_four_hour_minute
    result = MyTimeParser.new.parse('23:42').eval
    assert_equal 1_422, result
  end

  def test_hour_minute
    result = MyTimeParser.new.parse('3:16').eval
    assert_equal 196, result
  end

  def test_hour_minute_am
    result = MyTimeParser.new.parse('3:16am').eval
    assert_equal 196, result
  end

  def test_twelve_am
    result = MyTimeParser.new.parse('12:01am').eval
    assert_equal 1, result
  end

  def test_twelve_pm
    result = MyTimeParser.new.parse('12:01pm').eval
    assert_equal 721, result
  end

  def test_invalid_24_am
    assert_raises { MyTimeParser.new.parse('23:16am').eval }
  end

  def test_invalid_too_short
    assert_raises { MyTimeParser.new.parse('10').eval }
  end
end

if MiniTest.run
  puts 'SUCCESS'
end
