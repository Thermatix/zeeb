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

            # def request
            #     self.request
            #     # self.class.superclass.superclass.superclass.superclass.superclass.request
            # end

            def settings
                self.class.superclass.superclass.settings
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
                    self.sin = self.superclass
                    # subclass.send :def_delagator, self.sin, settings, settings
                    # delegate_basic_dsl_to subclass

                end


                def options hash
                    @options = hash
                end

                def method_added method
                    return if Delegation::SIN_DSL[:basic].include?(method)
                    r,paramaters = get_r_data method
                    
                    method_string = "#{method} "
                    method_string +=  paramaters.join(',') if paramaters

                    self.send r[:action], r[:url].first, (@options || {}) do
                        self.new.send method,*paramaters
                    end
                    @options = nil
            
                end

                def namespace namespace
                    self.current_namespace = namespace
                    yield
                    self.current_namespace = nil
                end

                private 
                def get_r_data method
                    r = {}
                    r[:action],r[:route] = method.to_s.split('_').map { |e| e.to_sym }
                    
                    paramaters = []
                    
                    r[:url] = Routes.instance_variable_get(:@routes)[r[:route]]
                    
                    if r[:url].last[:pass_through] != false
                        r[:url].first
                        .split('/').each do |param|
                            if param[0] == ':'
                                   paramaters << params[param.gsub(':','').to_sym]
                            end
                        end
                    end
                    return [r,paramaters]
                end

			end
			
    		register_component :controller

    		
			
		end
	end


end




