module Zeeb
	module Utils
	#a simplie utility module for small usefull methods

		module Singleton_Methods

			#adds a scope, so things inside don't exist outside of it
			def scope
				yield
			end
		end

		def self.included(base)
			base.extend Singleton_Methods
		end
	end
end