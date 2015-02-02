module Zeeb
	module Asset_Loader
		module Singleton_Methods

			def setup_asset_loader locations, frames

				main_css = []
				main_js = []

				zeeb_js = "#{Info[:zeeb_root]}/assets/js"
				zeeb_css = "#{Info[:zeeb_root]}/assets/css"
				zeeb_font = "#{Info[:zeeb_root]}/assets/fonts"

				zcss = '/zcss'
				zjs = '/zjs'
				zfont = '/zfont'

				if frames[:front_end]
					main_css << "/#{zcss}/materialize.min.css"
				end

				if frames[:front_end]
					main_js = [
						"#{zjs}/materialize.min.js",
						"#{zjs}/vendor/jquery-1.11.2.min.js"
					]
				end
				
				assets do
					locations.each do |url,path|
						serve url, from: path
					end	

			  		serve "#{zjs}", from: zeeb_js
			  		serve "#{zcss}", from: zeeb_css
			  		serve "#{zfont}", from: zeeb_font

			  		
			  		js :zeeb, main_js

			  		css :zeeb, main_css

			  		css_compression :sass
			  		js_compression  :yui, :munge => true 
			  	end
			end

		end


		def self.included(base)
			base.extend Singleton_Methods
		end

	end
end