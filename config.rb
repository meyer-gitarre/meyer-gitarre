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
# A path which all have the same layout
with_layout :layoutGit do
   page "/gitarre/*"
end
with_layout :layoutBfl do
   page "/blockfloete/*"
end
with_layout :layoutMus do
   page "/musiklehre/*"
end

# With alternative layout
page "/blockfloete/behandlung/index.html", :layout => :layoutImproved
#page "/*", :layout => :layoutImproved

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
	def menu_helper (cmd)
		fullCmd = 'node menu.js ' + cmd + ' -p '
		current_page.data.menuStructure.each do |entry|
			fullCmd += entry + ' '
		end
		#return %x[node menu.js menu -p Blockflöte]
		#tmp = 'node menu.js menu -p Blockflöte'
		return `#{fullCmd}`
	end
	
	def color_helper
		ancestor = current_page.data.menuStructure[0]
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
