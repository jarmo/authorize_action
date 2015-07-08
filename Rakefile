require "bundler/gem_tasks"

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)

task default: :spec

task "release:guard_clean" do
  calculate_checksum
end

def calculate_checksum
  require "digest/sha2"
  gem_spec = Gem::Specification.load(Dir.glob("*.gemspec")[0])
  gem_file_name = "#{gem_spec.name}-#{gem_spec.version}.gem"
  checksum = Digest::SHA512.new.hexdigest(File.read("pkg/#{gem_file_name}"))
  FileUtils.mkdir_p("checksum")
  checksum_file_path = "checksum/#{gem_file_name}.sha512"
  File.open(checksum_file_path, "w" ) {|f| f.write(checksum) }
  `git commit -m "Add checksum for #{gem_file_name}. #{checksum_file_path}"`
end
