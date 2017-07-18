# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pio/version'

Gem::Specification.new do |spec|
  spec.name = 'vihai-pio'
  spec.version = Pio::VERSION
  spec.summary = 'Packet parser and generator.'
  spec.description = 'Pure ruby packet parser and generator.'

  spec.licenses = %w[GPLv2 MIT]

  spec.authors = ['Yasuhito Takamiya']
  spec.email = ['yasuhito@gmail.com']
  spec.homepage = 'http://github.com/trema/pio'

  spec.files         = `git ls-files -z 2>/dev/null`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})

  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.3.0'

  spec.add_dependency 'bindata'#, '~> 2.4.0'
  spec.add_dependency 'activesupport', '~> 5.1.0'
end
