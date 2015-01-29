#@author Martin Becker
require 'sinatra'
require 'sinatra/form_helpers'
require "sinatra/namespace"
require 'sinatra/assetpack'
require 'yui/compressor'
require 'sass'
require 'yaml'
require 'json'
require 'inline'


%w( modules classes base).each do |folder|
	root = File.dirname(File.realpath(__FILE__))
	Dir.glob("#{root}/zeeb/#{folder}/*.rb") do |file|
		require file unless file =~ /\_old/
	end
end



