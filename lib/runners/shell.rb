require 'open3'

module Runners
  class Shell
    class << self
      def run(cmd)
        response, error_text, status = Open3.capture3(cmd)
        raise ShellError, "Command failed with exit code #{status.exitstatus}."\
          " Error details: `#{error_text.strip}`" if status.exitstatus != 0
        response&.strip
      end

      def run_and_parse(cmd, named_regex: nil, converters: {})
        parse_response(run(cmd), named_regex, converters)
      end

      private

      def parse_response(response, regex, converters)
        results = response.split("\n")
        return results unless regex

        results.each_with_object([]) do |line, results_array|
          parsed_line = line.match(regex)
          next unless parsed_line

          results_array << parsed_line.names.each_with_object({}) do |name, hash|
            converter = converters[name] || converters[name.to_sym] || ->(v) { v.to_s }
            hash[name] = converter.call(parsed_line[name])
          end
        end
      end
    end
  end

  class ShellError < StandardError; end
end
