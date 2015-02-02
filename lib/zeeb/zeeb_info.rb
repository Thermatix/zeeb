require File.expand_path './base/info', File.dirname(File.realpath(__FILE__))

module Zeeb
	class Info < Base::Info
		set :version, '0.0.1'
		set :name, 'zeeb'
		set :authors, %w{Thermatix}
		set :email, %w{mbeckerwork@gmail.com}
		set :description, 'A framework built ontop of sinatra DSL'
		set :licenses, %w{MIT}
		set :home, "https://github.com/JustGiving/zeeb"
		set :summary, 'A web frame work'
		set :zeeb_root, File.dirname(File.realpath(__FILE__))
		if defined? ::Sinatra
			set :helpers, [
						::Sinatra::FormHelpers,
						::Rack::Utils
						]
			set :exentions, [
						::Sinatra::AssetPack
					]
		end
	end

end