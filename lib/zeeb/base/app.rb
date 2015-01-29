module Zeeb
	module Base
		class App < ::Sinatra::Base
			include Sinatra_Register
			include Asset_Loader
			
			#register app components
			Register.non_internal_components Hash.new(
				::Sinatra::FormHelpers => :helpers,
				::Rack::Utils 		   => :helpers,
				::Sinatra::AssetPack   => :register
			)

			#only do these things after class has been inherited
			def self.inherited(base)
				Controller.app = base
				register_components_for base
			end

			def self.includes_hooks?
		    	%w(inherited)
		  	end
			
		end
	end
end

