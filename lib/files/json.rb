require 'json'

module Files
  class Json
    attr_reader :filepath

    def initialize(filepath)
      @filepath = filepath
    end

    def write(object)
      File.write(filepath, JSON.pretty_generate(object))
      object
    end

    def read(not_found_result = :raise)
      parse_json(File.read(filepath), not_found_result)
    rescue Errno::ENOENT => e
      raise e if not_found_result == :raise
      not_found_result
    end

    private

    def parse_json(json, not_found_result)
      return not_found_result if json&.strip&.empty? && not_found_result != :raise
      JSON.parse(json)
      # TODO: how to handle the send_email_queue bug?
    rescue JSON::ParserError => e
      raise e if not_found_result == :raise
      not_found_result
    end
  end
end
