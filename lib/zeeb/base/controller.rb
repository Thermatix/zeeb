module Zeeb	
	module Base
		class Controller 

            include Register_Self
            include  Covered
            include Delegation
            extend Forwardable

            [:get, :post, :put, :delete, :head, :options, :patch, :link, :unlink].each do |func_name|
                # alias_method :"old_#func_name" func_name
                define_singleton_method func_name do |*args,&block|
                    superclass.send func_name, *args do
                        block.call
                    end
                end
            end

           def cont
            ::Zeeb::Base::Controller
           end

            

            def settings
                self.class.superclass.superclass.settings
            end

            # def request
            #     cont.request
            # end

            # def response
            #     cont.response
            # end

            # def env
            #     cont.env
            # end
                      
            class << self            
                attr_accessor :app,:current_namespace, :instance, :routes, :env, :request,:response

                def inherited subclass
                    subclass.instance = subclass.new
                end

                # def request
                #     self.superclass.instance.request
                # end


                # def request= value
                #     self.superclass.instance.request = value
                # end


                def options hash
                    @options = hash
                end

                def method_added method
                    return if Delegation::SIN_DSL[:basic].include?(method)
                    r,p = get_r_data method
                    m = self.instance.method(method)
                    self.send r[:action], r[:url].first, (@options || {}), (m.arity < 1 ) ?  m.call : m.call(*p) 
                    @options = nil
            
                end

                def namespace namespace
                    self.current_namespace = namespace
                    yield
                    self.current_namespace = nil
                end


                private 

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




