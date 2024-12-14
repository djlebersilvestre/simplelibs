require_relative 'json'
require_relative '../runners/shell'

module Files
  class Ejson < Json
    def write(object)
      super(object)
      Runners::Shell.run("ejson encrypt #{filepath}")
      object
    end

    def read(not_found_result = :raise)
      parse_json(
        Runners::Shell.run("ejson decrypt #{filepath}"),
        not_found_result
      )
    rescue Runners::ShellError => e
      raise e if not_found_result == :raise || e.message !~ /#{filepath}: no such file or directory/
      not_found_result
    end
  end
end
