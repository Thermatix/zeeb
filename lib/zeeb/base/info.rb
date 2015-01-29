module Zeeb	
	module Base
		class Info
			include Register_Self
    		register_component :info
    		
			module Singleton_Methods
				include Utils
								
				def [](key)
					@store[key]
				end

				def display
					@store.inspect
				end

				private
					def set key, value
						@store[key] = value
					end
			end
			
			
			def self.inherited(base)
				base.instance_variable_set :@store, {}
				base.extend Singleton_Methods
			end

			def self.includes_hooks?
		    	%w(inherited)
		  	end
	  	end
	end
end