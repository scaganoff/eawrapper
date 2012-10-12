
lib=File.expand_path('./lib/', __FILE__)
$:.unshift(lib) unless $:.include?(lib)

spec = Gem::Specification.new do |s|
  s.name = 'eawrapper'
  s.version = '0.0.27'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README', 'LICENSE']
  s.summary = 'Ruby wrapper for Sparx Enterprise Architect'
  s.description = s.summary
  s.author = 'Saul Caganoff'
  s.email = 'scaganoff@gmail.com'
  # s.executables = ['your_executable_here']
  s.files = %w(LICENSE README Rakefile) + Dir.glob("{bin,lib,spec}/**/*")
  s.require_path = "lib"
  s.bindir = "bin"
end
