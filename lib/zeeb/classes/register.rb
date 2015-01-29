module Zeeb
	class Register
		class << self
			attr_accessor :comps, :registerd

			def this component,kind
				@components ||= {}
				@components[component.to_S] = kind
			end


			def [](key)
				@components[key]
			end

			def components
				@components.each do |component,kind|
					yield [component,kind]
					@components.delete(component)
					self.registerd.push component
				end
			end

			def non_internal_components hash
				@components ||= {}
				@components = @components.merge(hash)
			end
		end
		self.comps = {}
		self.registerd = []
	end
end
