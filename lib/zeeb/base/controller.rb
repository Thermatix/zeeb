module Zeeb	
	module Base
		class Controller
			class << self
				attr_accessor :app
			end

			include Register_Self
			include  Covered
    		register_component :controller

    		def self.inherited
    			self.set_super(self.app)
    		end

    		def self.method_added method
    			action,route = method.split('_')
    			self.instance_eval %{
    				#{action} \'#{route}\' do
    					#{method}
    					erb self.controller.to_s.downcase
    				end
    			}
    		end

    		def self.namespace namespace
    			self.current_namespace = namespace
    			yield
    			self.current_namespace = nil
    		end
			
		end
	end
end