#!/usr/bin/env ruby

require 'minitest'

module RegexTime
  class ParseError < StandardError ; end

  class << self
    def parse(str)
      case str
      when /^(\d+):(\d{2})$/
        (hour($1, twenty_four: true) * 60) + minute($2)
      when /^(\d+):(\d{2})([ap]m)$/
        (hour($1) * 60) + minute($2) + am_pm($3)
      when /^(\d+)([ap]m)$/
        (hour($1) * 60) + am_pm($2)
      else
        raise ParseError, "'#{str}' is not a supported time format"
      end
    end

    private

    def am_pm(str)
      str == 'pm' ? 12 * 60 : 0
    end

    def hour(str, twenty_four: false)
      value = str.to_i
      raise ParseError, "'#{value}' is not a valid hour" if value > (twenty_four ? 23 : 12)

      value = 0 if value == 12 && !twenty_four
      value
    end

    def minute(str)
      value = str.to_i
      raise ParseError, "'#{value}' is not a valid minute" if value > 59

      value
    end
  end
end

class RegexTimeTest < MiniTest::Test
  def test_hour_pm
    result = RegexTime.parse('4pm')
    assert_equal 960, result
  end

  def test_hour_minute_pm
    result = RegexTime.parse('7:38pm')
    assert_equal 1_178, result
  end

  def test_twenty_four_hour_minute
    result = RegexTime.parse('23:42')
    assert_equal 1_422, result
  end

  def test_hour_minute
    result = RegexTime.parse('3:16')
    assert_equal 196, result
  end

  def test_hour_minute_am
    result = RegexTime.parse('3:16am')
    assert_equal 196, result
  end

  def test_twelve_am
    result = RegexTime.parse('12:01am')
    assert_equal 1, result
  end

  def test_twelve_pm
    result = RegexTime.parse('12:01pm')
    assert_equal 721, result
  end

  def test_invalid_24_am
    assert_raises { RegexTime.parse('23:16am') }
  end

  def test_invalid_too_short
    assert_raises { RegexTime.parse('10') }
  end

  def test_invalid_blank
    assert_raises { RegexTime.parse('') }
  end
end

if MiniTest.run
  puts 'SUCCESS'
end
