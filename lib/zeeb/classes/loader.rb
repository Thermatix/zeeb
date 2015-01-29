module Zeeb	
	class Loader
		class << self
			attr_accessor :logger, :files, :root, :paths, :context, :paths_appended, :paths_pre_appended

			def load_files logger
				log 'Loading files',logger

				if self.paths_pre_appended
					require_files self.paths_pre_appended
				end
				
				self.paths.each do |folder,files|
					log "Loading files from #{folder}"
					require_files files
				end
				
				if self.paths_appended
					log 'Loading '
					require_files self.paths_appended

				end

			end

			def require_files files
				files.each do |file|
					log "Loading #{File.basename(file,'.rb')}"
					self.context.send :require, file
				end
			end

			def append_file file
				(self.paths_appended ||= []).push(file)
			end
			def pre_append file
				(self.paths_pre_appended ||= []).push(file)
			end
			
			private 

			def log msg, logger
				if Register.comp[:log]
					Register.comp[:log][:info] = msg 
				else
					logger.info msg
				end
			end
				def auto_path
					self.paths ||= Dir.chdir(Dir.pwd) do
						%w(
							lib
							initializers 
							helpers 
							models 
							controllers
						).inject({}) do |result,folder|
							result[folder.to_sym] = File
								.expand_path(Dir
									.glob("./**/**/#{folder}")
								)
							result
						end
					end
				end

		end
	end
end
