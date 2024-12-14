class Simplelibs
  VERSION = '0.0.1'
end

ROOT_DIR = File.expand_path(File.join(__dir__, '..'))
TMP_DIR = File.join(ROOT_DIR, 'tmp')

# TODO: does not work for other gems given the constants are fixed
def require_local(relative_path)
  require_relative File.join(ROOT_DIR, 'lib', relative_path)
end

def require_from_gem(path)
  match = path.match(/(?<gem_name>^.+?)\/(?<relative_path>.*)/)
  # TODO: memoize in a hash
  gem_dir = Gem::Specification.find_by_name(match[:gem_name]).gem_dir
  require "#{gem_dir}/lib/#{match[:relative_path]}"
end
