module Zeeb	
	module Base
		class Controller

            include Register_Self
            include  Covered

			class << self            
                attr_accessor :app,:current_namespace, :sin
                
                #intercept normal sinatra route DSL calls
                %w(get post put delete head options patch link unlink).each do | func_name|
                    define_method func_name do |*args|
                        checking do |*args|
                            # self.superclass.sin.send(func_name, *args)
                            self.superclass.sin.instance_eval do
                                super(*args)
                            end
                        end
                    end
                end
      
                def checking *args
                    args[0]=check(args.first)
                    yield(*args)
                end

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

                def inherited subclass
                    #grab a refrence to the sinatra class
                    self.sin = self.superclass.superclass.superclass
                end

                def method_added method
                    action,route = method.to_s.split('_')
                    paramaters = []
                    r = ::Zeeb::Routes.instance_variable_get(:@routes)[route.to_sym]
                    if r.last[:pass_through] != false
                        r.first
                        .split('/').each do |param|
                            if param[0] == ':'
                                   paramaters << params[param.gsub(':','').to_sym]
                            end
                        end
                    end
                    self.instance_eval "
                        #{action} :#{route} do
                            #{method} #{paramaters.join(' ') if paramaters} 
                        end
                    ",__FILE__,__LINE__
                end

                def namespace namespace
                    self.current_namespace = namespace
                    yield
                    self.current_namespace = nil
                end

			end
			
    		register_component :controller

    		
			
		end
	end


end




