source ENV['GEM_SOURCE'] || 'https://rubygems.org'

# The development group is intended for developer tooling. CI will never install this.
group :development do
  gem 'guard-rake',   require: false
end

# The test group is used for static validations and unit tests in gha-puppet's
# basic and beaker gha-puppet workflows.
group :test do
  # Needed to build the test matrix based on metadata
  gem 'puppet_metadata', '~> 4.0',  require: false
  # metagem that pulls in all further requirements
  gem 'voxpupuli-test', '~> 7.0', require: false
end

# The system_tests group is used in gha-puppet's beaker workflow.
group :system_tests do
  gem 'voxpupuli-acceptance', '~> 2.1', require: false
end

# The release group is used in gha-puppet's release workflow
group :release do
  gem 'voxpupuli-release', '~> 3.0', '>= 3.0.1'
end

gem 'rake', :require => false
gem 'facter', ENV['FACTER_GEM_VERSION'], :require => false, :groups => [:test]


puppetversion = ENV['PUPPET_GEM_VERSION'] || '~> 7.24'
gem 'puppet', puppetversion, :require => false, :groups => [:test]