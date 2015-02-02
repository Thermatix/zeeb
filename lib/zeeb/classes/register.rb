module Zeeb
	class Register
		class << self
			attr_accessor :comps, :registered

			def this component,kind
				@components ||= {}
				@components[kind].push component
			end


			def [](key)
				@components[key]
			end

			def components
				@components.each do |kind,components|
					components.each do |component|
						yield(kind,component)
						self.registered.push component
					end
					@components[kind] = []
				end
			end

			def non_internal_components hash
				@components ||= {}
				
				@components = @components.merge(hash)
			end
		end
		self.comps = {}
		self.registered = []
	end
end
