module Zeeb	
	class Loader
		@paths = {}
		@pre_loaded = []
		class << self
			attr_accessor :logger, :files, :root

			def set_up 
				self.logger = logger unless Register.comps[:log]
				self.root = root
				self.files = []
				@paths = auto_paths
			end

			def get_file_listing 
				@paths.each do |name,path|
					self.files.push Dir["#{path}/*.rb"]

				end
				self.files = self.files.flatten
			end

			def append_file file, root=nil
				path = "#{root||self.root}/#{file}"
				self.files.push path
			end

			def prepend_file file, root=nil
				path = "#{root||self.root}/#{file}"
				self.files.unshift path
			end		

			def require_files context
				get_files :require,context
			end

			def reload_files context
				get_files :load,context
			end
			
			def reload_file file,context
				get_file :load, file, context
			end

			def pre_load context,*files
				puts 'pre-loading files'
				root = File.dirname(File.realpath(__FILE__))	
				%w( logging info  covered ).each do |file|
					get_file :require, 
					File.expand_path("#{root}/#{file}"), 
					context
				end	
				@paths[:initializers] = get_folder 'initializers'
				
				files.each do |file|
					@pre_loaded.push file
					get_file :require, 
					"#{@paths[:initializers]}/#{file}", 
					context
				end			
			end

			private 

			def auto_paths
				Dir.chdir(Dir.pwd) do
					%w(lib 
						initializers 
						helpers 
						models 
						controllers
					).inject({}) do |result,folder|
						result[folder.to_sym] = get_folder folder
						result
					end
				end
			end

			def get_folder folder
				Dir.chdir(Dir.pwd) do
					File.expand_path(Dir.glob("./**/**/#{folder}").first)
				end
			end

				def get_files method, context
					self.files.each do |file|
						get_file method, file, context
					end	
				end


				def get_file method, file,context
					l = logger || self.logger || nil unless Register.comps[:log]
					if context.send method, file
						msg = "loaded #{File.basename(file,'.rb')}"
						if l
							puts msg
							l.info msg
						else
							Register.comps[:log][:info] = msg
						end
					end
				end
		end
	end
end