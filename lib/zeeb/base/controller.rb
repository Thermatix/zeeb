module Zeeb	
	module Base
		class Controller

            include Register_Self
            include  Covered

			class << self
				attr_accessor :app
               
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




