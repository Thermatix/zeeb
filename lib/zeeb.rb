#@author Martin Becker
require 'sinatra'
require 'sinatra/form_helpers'
require 'sinatra/assetpack'
require 'yui/compressor'
require 'sass'
require 'yaml'
require 'json'
require 'inline'



%w( modules patches classes base).each do |folder|
	root = "#{File.dirname(File.realpath(__FILE__))}/zeeb"
	require File.expand_path("#{root}/zeeb_info")
	Dir.glob("#{root}/#{folder}/*.rb") do |file|
		require file unless file =~ /\_old/
	end
end



