
module Zeeb	
	module Covered
		module Singleton_Methods

			def set_logger logger
				@logger = logger
			end

			def logger
				@logger
			end

			def cover override=nil
				begin
					yield
				rescue Exception => err
					fatal = (override == :fatal)
					msg =[
			            "#{err}",
			            "stacktrace=#{err.backtrace.join("\n")}"
			        ]
			        if Register.comps[:log]
			        	Register.comps[:log][override || :error] = msg
			        else
				        msg.each do |line|
				        	puts line unless fatal
				        	(logger.send override || :error, line )if logger
				        end
				    end
			        raise if fatal
				end
			end

		end

		def self.included(base)
			base.instance_variable_set :@logger, {}
			base.extend Singleton_Methods
		end

		def self.includes_hooks?
	    	%w(included)
	  	end

	end
	class Zeeb < ::Sinatra::Base
		include Covered
	end
end