module Zeeb	
	class Loader
		class << self
			attr_accessor :logger, :files, :root, :paths, :context, :paths_appended, :paths_pre_appended

			def init context
				self.context = context
				self.paths = auto_path
			end

			def load_files logger=nil
				# log 'Loading files',logger

				if self.paths_pre_appended
					require_files_in self.paths_pre_appended
				end
				
				self.paths.each do |folder_name,folder|
					# log "Loading folder from #{folder}"
					require_files_in folder
				end
				
				if self.paths_appended
					# log 'Loading '
					require_files_in self.paths_appended
				end

			end

			

			def append_file file
				(self.paths_appended ||= []).push(file)
			end

			def pre_append file
				(self.paths_pre_appended ||= []).push(file)
			end
			
			private 

				def require_files_in folder
					Dir.chdir(folder) do
						Dir.glob("./*.rb").each do |file|
							# log "Loading #{File.basename(file,'.rb')}"
							puts "Loading #{File.basename(file,'.rb')}"
							self.context.send :require, file
						end
					end
				end

				def log msg, logger
					if Register.comps[:log]
						Register.comps[:log][:info] = msg 
					else
						logger.info msg
					end
				end

				def auto_path
					return Dir.chdir(Dir.pwd) do
						%w( initializers
							lib
							helpers 
							models 
							controllers
						).inject({}) do |result,folder|
								Dir.glob("./**/**/#{folder}").map do |path|
									result[folder.to_sym] = File.expand_path(path)
								end
							result
						end
					end
				end

		end
	end
end
