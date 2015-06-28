###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
#

#Disable all Layouts
#set :layout, false

# Proxy pages (https://middlemanapp.com/advanced/dynamic_pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", :locals => {
#  :which_fake_page => "Rendering a fake page with a local variable" }

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
 configure :development do
   activate :livereload
 end

# Methods defined in the helpers block are available in templates
helpers do
	def color_helper
		if current_page.data.menuStructure?
			ancestor = current_page.data.menuStructure[0]
		end
		if ancestor == 'Blockflöte'
			return 'bflColor'
		end
		if ancestor == 'Gitarre'
			return 'gitColor'
		end
		if ancestor == 'Musiklehre'
			return 'musColor'
		end
		return 'defaultColor'
	end

	def minimenu_helper
		html = ''
		html += '<ul>'
		html += '<li><a href="/index.html">Home</a></li>'

		if current_page.data.menuStructure?
			ancestor = current_page.data.menuStructure[0]
		else
			ancestor = 'default'
		end

		if ancestor == 'Blockflöte'
			html += '<li><a href="/blockfloete/index.html">Blockflöte</a></li>'
			html += '<li><a href="/blockfloete/index.html#stichwortverzeichnisbfl">Stichworte</a></li>'
		end

		if ancestor == 'Musiklehre'
			html += '<li><a href="/musiklehre/index.html">Musiklehre</a></li>'
			html += '<li><a href="/musiklehre/index.html#stichwortverzeichnismusik">Stichworte</a></li>'
		end

		if ancestor == 'Gitarre'
			html += '<li><a href="/gitarre/index.html">Gitarre</a></li>'
			html += '<li><a href="/gitarre/index.html#stichwortverzeichnisgitarre">Stichworte</a></li>'
		end

		if ancestor != 'Blockflöte' && ancestor != 'Musiklehre' && ancestor != 'Gitarre'
			html += '<li><a href="/gitarre/index.html">Gitarre</a></li>'
			html += '<li><a href="/musiklehre/index.html">Musiklehre</a></li>'
			html += '<li><a href="/blockfloete/index.html">Blockflöte</a></li>'
			html += '<li><a href="/meta/sitemap.html">Sitemap</a></li>'
		end

		html += '</ul>'
	end
end

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end
