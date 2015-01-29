module Zeeb
	module Base
		class App < ::Sinatra::Base
			include Sinatra_Register
			class << self
				attr_accessor :current_namespace
				#intercept normal sinatra route DSL calls
			 	def get(*args)args[0]=check(args.first);super(*args);end
			    def put(*args)args[0]=check(args.first);super(*args);end
			    def post(*args)args[0]=check(args.first);super(*args);end
			    def delete(*args)args[0]=check(args.first);super(*args);end
			    def head(*args)args[0]=check(args.first);super(*args);end
			    def options(*args)args[0]=check(args.first);super(*args);end
			    def patch(*args)args[0]=check(args.first);super(*args);end
			    def link(*args)args[0]=check(args.first);super(*args);end
			    def unlink(*args)args[0]=check(args.first);super(*args);end

				def check path
					if path.class == Symbol
						[
							self.current_namespace || '',
							Routes.instance_variable_get(:@routes)[path]
						].join
					else
						path
					end
				end

			end
			#register app components
			Register.non_internal_components Hash.new(
				::Sinatra::FormHelpers => :helpers,
				::Rack::Utils 		   => :helpers,
				::Sinatra::Namespace   => :register,
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

