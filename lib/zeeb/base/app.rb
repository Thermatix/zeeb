module Zeeb
	module Base
		class App < ::Sinatra::Base
			include Sinatra_Register
			include Asset_Loader
			include Delegation
				
			#register app components
			Register.non_internal_components({
				helpers: ::Zeeb::Info[:helpers],
				register: ::Zeeb::Info[:extensions]
			})
			# delegate_basic_dsl_to self

			[:get, :post, :put, :delete, :head, :options, :patch, :link, :unlink].each do |func_name|
				define_singleton_method func_name do |*args,&block|
					super(*args) do
                        block.call
                    end
				end
			end

			class << self

				
				def inherited(subclass)
					super
					Controller.set_super(subclass)
					register_components_for subclass
					delegate_basic_dsl_to subclass 
					after_inherited do
						Loader.init subclass
						Loader.load_files
					end
				end

				def includes_hooks?
			    	%w(inherited)
			  	end


			 end
			
		end
	end
end

