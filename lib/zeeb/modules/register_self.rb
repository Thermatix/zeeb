module Zeeb
	module Register_Self
		#allows methods to tell the register that they exist
		module Singleton_Methods
			#@param [set] when this is passed will tell the register what kind of module is being registered
			def register_self_as set=nil
				if set
					@kind = set
					Register.this(self, @kind)
				else
					@kind
				end
			end

			#@param [comp] this is what the class is being registered as, i.e. log component
			def register_component comp
				Register.comps[comp] = self
			end


		end

		def self.included(base)
			base.extend Singleton_Methods
			base.instance_variable_set :@kind, {}
		end

		def self.includes_hooks?
	    	%w(included)
	  	end
	end
end
