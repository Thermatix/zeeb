module Zeeb	
	module Base
		class Controller 

            include Register_Self
            include  Covered
            include Delegation

            [:get, :post, :put, :delete, :head, :options, :patch, :link, :unlink].each do |func_name|
                # alias_method :"old_#func_name" func_name
                define_singleton_method func_name do |*args,&block|
                    superclass.send func_name, *args do
                        block.call
                    end
                end
            end

            class << self            
                attr_accessor :app,:current_namespace, :sin
                
                               
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
                    self.sin = self.superclass.superclass
                    # delegate_basic_dsl_to subclass

                end

                def method_added method
                    return if Delegation::SIN_DSL[:basic].include?(method)
                    @r = {}
                    @r[:action],@r[:route] = method.to_s.split('_').map { |e| e.to_sym }
                    puts [@r[:action],@r[:route]].inspect
                    paramaters = []
                    
                    @r[:url] = Routes.instance_variable_get(:@routes)[@r[:route]]
                    
                    if @r[:url].last[:pass_through] != false
                        @r[:url].first
                        .split('/').each do |param|
                            if param[0] == ':'
                                   paramaters << params[param.gsub(':','').to_sym]
                            end
                        end
                    end

                    method_string = "#{method} "
                    method_string +=  paramaters.join(',') if paramaters

                    self.send @r[:action], @r[:url].first, {} do
                        self.instance_eval "self.new.#{method_string}"
                    end
                    
            


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




