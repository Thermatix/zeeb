module Zeeb	
	module Base
		class Info
			if defined? Register_Self
				include Register_Self 
	    		register_component :info
	    	end
    		
			module Singleton_Methods
				include Utils if defined? Utils 
								
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