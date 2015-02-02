# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require  './lib/zeeb/zeeb_info'
ignore_list = %w(.git .gitignore .gitattributes  *.gem)
folder_list = %w(lib spec bin tasks).join(',')

Gem::Specification.new do |spec|
  spec.name          = Zeeb::Info[:name]
  spec.version       = Zeeb::Info[:version]
  spec.authors       = Zeeb::Info[:authors]
  spec.email         = Zeeb::Info[:email]
  spec.summary       = Zeeb::Info[:summary]
  spec.description   = Zeeb::Info[:description]
  spec.homepage      = Zeeb::Info[:home]
  spec.licenses      = Zeeb::Info[:licenses]

  spec.files         = (Dir.glob("{#{folder_list}}/**/**/*") + Dir.glob("*").reject { |file| ignore_list.include?(file)})#.map  {|file_path| file_path.gsub('/','\\')}
  spec.executables   = "zeeb"
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  

  #application dependencies
  spec.add_runtime_dependency "rack", "1.6.0"
  spec.add_runtime_dependency "sinatra", "1.4.5"
  spec.add_runtime_dependency "sinatra-formhelpers-ng","1.9.0"
  spec.add_runtime_dependency "sinatra-assetpack","0.3.3"
  spec.add_runtime_dependency "json","1.8.2"
  spec.add_runtime_dependency "yui-compressor", "0.12.0"
  spec.add_runtime_dependency "RubyInline", "3.12.3"
  spec.add_runtime_dependency "sass","3.2.19"
  spec.add_runtime_dependency "thin","1.6.3"


  #testing dependencies
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rack-test", "0.6.3"
  spec.add_development_dependency "rspec","3.1.0"
  spec.add_development_dependency "fuubar","2.0.0"

end