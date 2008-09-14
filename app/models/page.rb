class	Page
	attr_accessor :content, :title, :summary, :path, :layout_template, :raw_content

	class PageNotFoundException < Exception ; end
	
	PAGES_ROOT = "#{RAILS_ROOT}/pages"
	SUFFIX = ".html.erb"
	
	def self.exists?(path)
		File.exists? self.file_path(path)
	end
	
	def self.file_path(path)
		"#{PAGES_ROOT}/#{path.join("/")}#{SUFFIX}"
	end
	
	def self.dir_path(path)
		"#{PAGES_ROOT}/#{path.join("/")}/"
	end
	
	def self.roots()
		Dir.glob("#{PAGES_ROOT}/*#{SUFFIX}").collect{ |file_path|
			Page.new :file_path => file_path
		}.sort_by(&:title)
	end
	
	def self.file_path_to_path(file_path)
		file_path && Pathname.new(file_path).
			cleanpath.
			relative_path_from(Pathname.new(PAGES_ROOT).cleanpath).
			to_s.chomp("#{SUFFIX}").
			split("/")
	end
	
	def find_all
		return []
	end
	
	def self.find(options = {})
		return self.find_all if options == :all
		if Page.exists?(options[:path] || Page.file_path_to_path(options[:file_path]) || ["index"])
			Page.new(options)
		else
			nil
		end
	end
	
	def initialize(options = {})
		@content_view = ActionView::Base.new(ActionView::TemplateFinder.process_view_paths(PAGES_ROOT), {:page => self}, self)
		if options[:path] or options[:file_path]
			@path = if options[:file_path]
				Page.file_path_to_path(options[:file_path])
			else
				options[:path]
			end
			@content = self.content
		else
			@path = ["index"]
			@content = self.content
		end
	end
	
	def file_path
		Page.file_path(self.path)
	end
	
	def dir_path
		Page.dir_path(self.path)
	end
	
	def raw_content
		@raw_content ||= IO.read(self.file_path)
	end
	
	def content
		@content ||= @content_view.render_file(self.path.join("/"))
	end
	
	def summary
		@summary ||= self.content
	end
	
	def summarize(options = {}, &block)
		@summary = @content_view.capture(&block)
		if options[:render] then @content_view.concat(@summary, block.binding) end
		@summary
	end
	
	def name
		@name || self.path.last
	end
	
	def title
		@title || self.name.titleize
	end
	
	def children
		@children ||= Dir.glob("#{self.dir_path}/*#{SUFFIX}").collect do |path|
			Page.new(:file_path => path)
		end
	end
	
	def updated_at
		File.mtime(self.file_path)
	end
	
	def created_at
		File.ctime(self.file_path)
	end
	
	def to_param
		self.path.join("/")
	end
	
	def new_record?
		!Page.exists?(self.path)
	end
end