module Zeeb
	module Base
		class App < ::Sinatra::Base
			include Sinatra_Register
			include Asset_Loader
			

			#register app components
			Register.non_internal_components({
				helpers: ::Zeeb::Info[:helpers],
				register: ::Zeeb::Info[:extensions]
			})

			class << self

				#push requests up to sinatra from controllers
				def get;super; end
				def put;super; end
				def post;super; end
				def delete;super; end
				def head;super; end
				def options;super; end
				def patch;super; end
				def link;super; end
				def unlink;super; end


				def inherited(subclass)
					super
					Controller.set_super(subclass)
					register_components_for subclass
					Loader.init subclass
					Loader.load_files
				end

				def includes_hooks?
			    	%w(inherited)
			  	end


			 end
			
		end
	end
end

