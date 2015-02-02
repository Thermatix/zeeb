module Zeeb
	module Sinatra_Register
		#dsl method for registering modules for a particular context
		module Singleton_Methods

			#@param [context] takes in class, this is the class that will have modules registered for it
			def register_components_for context
				Register.components do |method,component|
					puts "registering #{component} with #{method}"
					context.instance_eval "#{method} #{component}",__FILE__,__LINE__
				end
			end

		end

		def self.included(base)
			base.extend Singleton_Methods
		end

		def self.includes_hooks?
	    	%w(included)
	  	end
	end
end