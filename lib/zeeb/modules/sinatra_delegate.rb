
module Zeeb
	module Delegation
		SIN_DSL = {
			basic: [ :get, :post, :put, :delete, :head, :options, :patch, :link, :unlink]
		}

		extend Forwardable

		module Singleton_methods

			def delegate_basic_dsl_to context
				context.extend Forwardable
				context.send :def_delegators, superclass, :get, :post, :put, :delete, :head, :options, :patch, :link, :unlink
				# SIN_DSL[:basic].each do |func|
				# 	context.send :def_delegator, superclass, func, func
				# end
			end

		end

		def self.included(base)
			base.extend Singleton_methods
		end
	end
end