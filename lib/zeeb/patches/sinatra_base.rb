# # # module Zeeb	
# # # 	module Base
# # # 		class Controller
# # # 		end
# # # 	end
# # # end

# class ::Sinatra::Base

# 	# alias_method :orig_call!, :call!

# 	def call!(env)
# 		cont = ::Zeeb::Base::Controller
# 		@env      = env
# 		@request  = Request.new(env)
# 		@response = Response.new
# 		@params   = indifferent_params(@request.params)
		
# 		template_cache.clear if settings.reload_templates
# 		force_encoding(@params)

# 		@response['Content-Type'] = nil
# 		invoke { dispatch! }
# 		invoke { error_block!(response.status) } unless @env['sinatra.error']

# 		unless @response['Content-Type']
# 			if Array === body and body[0].respond_to? :content_type
# 			  content_type body[0].content_type
# 			else
# 			  content_type :html
# 			end
# 		end

# 		cont.env = @env
# 		cont.request = @request 
# 		cont.params = @params

# 		ret = @response.finish
# 		cont.response = ret
# 		ret

# 	end
# end