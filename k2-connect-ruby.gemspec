lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'k2-connect-ruby/version'

Gem::Specification.new do |spec|
  spec.name                  = 'k2-connect-ruby'
  spec.version               = K2ConnectRuby::VERSION
  spec.authors               = ['DavidKar1uk1']
  spec.email                 = ['David.mwangi@kopokopo.com']

  spec.summary               = 'Ruby SDK for the Kopo Kopo K2 Connect API.'
  spec.description           = 'Ruby SDK for the Kopo Kopo K2 Connect API, with webhook subscriptions, STK Push, Pay and Settlement Transfer capabilities. Allows decomposition and break down of results and webhooks returned from the K2 Connect APIx``.'
  spec.homepage              = 'https://github.com/kopokopo/k2-connect-ruby.git'
  spec.license               = 'MIT'
  spec.required_ruby_version = '~> 3.3.5'


  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'

    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'https://github.com/kopokopo/k2-connect-ruby.git'
    spec.metadata['changelog_uri'] = 'https://github.com/kopokopo/k2-connect-ruby.git/CHANGELOG.MD'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']


  spec.add_dependency 'activesupport', '~> 7.2.2'
  spec.add_dependency 'activemodel', '~> 7.2.2'
  spec.add_dependency 'rest-client', '~> 2.1.0'
  spec.add_dependency 'json', '~> 2.8.2'
  spec.add_development_dependency 'bundler', '~> 2.5.16'
  spec.add_development_dependency "guard", '~> 2.19'
  spec.add_development_dependency "guard-rspec", '~> 4.7.3'
  spec.add_development_dependency 'rake', '~> 13.2.1'
  spec.add_development_dependency 'rspec', '~> 3.13.0'
  spec.add_development_dependency "rspec-nc", '~> 0.3.0'
  spec.add_development_dependency 'vcr', '~> 6.3.1'
  spec.add_development_dependency 'webmock', '~> 3.24'
  spec.add_development_dependency 'faker', '~> 3.5.1'
end
