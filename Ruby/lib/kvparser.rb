module KeyValueParser
	extend self

	def parse(str, options = {})
		result = {}
		options[:sep_char] ||= '='
		options[:line_char] ||= "\n"
		options[:trim_values] = true unless options.include?(:trim_values)
		options[:comment_char] ||= '#'

		str.gsub!("\r\n", "\n") if (options[:line_char] == "\n")

		str.each_line(options[:line_char]) { | line |
			line = line.gsub!(/^#{options[:line_char]}*/, '').gsub(/#{options[:line_char]}*$/, '')
			unless line.strip.empty?
				key, value = line.split(options[:sep_char], 2)
				unless value.nil?
					key.strip!
					if (options[:comment_char] == '') || (!key.start_with?(options[:comment_char]))
						key.gsub!(' ', '_')
						value.strip! if options[:trim_values]
						result[key.to_sym] = value
					end
				end
			end
		}
		return result
	end

end