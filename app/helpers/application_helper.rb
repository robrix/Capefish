# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	def pngfix
		<<-PNGFIX
	<!--[if lt IE 7]>
	#{javascript_include_tag "pngfix", :cache => true}
	<![endif]-->
		PNGFIX
	end
end
