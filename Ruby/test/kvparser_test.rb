require '../lib/kvparser'
require 'test/unit'

class KeyValueParserTest < Test::Unit::TestCase

	# Called before every test method runs. Can be used
	# to set up fixture information.
	def setup
		@test_str1 = <<-eos
# This is a test file for the KeyValueParser. You may use empty lines and # for comments
test1 = This is a test key
test2 = This is another sentence
test3 = true
test4 = This is another test using another = symbol

	# This = should be comment

123 = 123
test4 key = false
		eos

		@test_str2 = 'key1=value1&key2=value2&key3=value3'
	end

	# Called after every test method runs. Can be used to tear
	# down fixture information.

	def teardown
		# Do nothing
	end

	def test_parse
		expected = {
			:test1 => 'This is a test key',
		  :test2 => 'This is another sentence',
		  :test3 => 'true',
      :test4 => 'This is another test using another = symbol',
			:'123' => '123',
		  :test4_key => 'false'
		}
		assert_equal(expected, KeyValueParser.parse(@test_str1))

		expected = {
			:test1 => 'This is a test key',
			:test2 => 'This is another sentence',
			:test3 => 'true',
      :test4 => 'This is another test using another = symbol',
			:'#_This' => 'should be comment',
			:'123' => '123',
			:test4_key => 'false'
		}
		assert_equal(expected, KeyValueParser.parse(@test_str1, :comment_char => ''))


		expected = {
			:key1 => 'value1',
			:key2 => 'value2',
			:key3 => 'value3'
		}
		assert_equal(expected, KeyValueParser.parse(@test_str2, :line_char => '&'))
	end

end