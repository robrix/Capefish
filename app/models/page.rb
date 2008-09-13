class	Page
	attr_accessor :content, :title, :summary, :path
	attr_reader :format

	class PageNotFoundException < Exception ; end
	
	PAGES_ROOT = "#{RAILS_ROOT}/pages"
	
	def self.exists?(path, format)
		File.exists? self.file_path(path, format)
	end
	
	def self.file_path(path, format)
		"#{PAGES_ROOT}/#{path.join("/")}.#{self.extension_for_format(format)}.erb"
	end
	
	def self.dir_path(path)
		"#{PAGES_ROOT}/#{path.join("/")}/"
	end
	
	def self.roots(format = Mime::EXTENSION_LOOKUP["html"])
		Dir.glob("#{PAGES_ROOT}/*.#{Page.extension_for_format format}.erb").collect do |file_path|
			Page.new :file_path => file_path, :format => format
		end
	end
	
	def self.file_path_to_path(file_path, format)
		file_path && Pathname.new(file_path).
			cleanpath.
			relative_path_from(Pathname.new(PAGES_ROOT).cleanpath).
			to_s.chomp(".#{Page.extension_for_format(format)}.erb").
			split("/")
	end
	
	
	def self.find(options = {})
		if Page.exists?(options[:path] || Page.file_path_to_path(options[:file_path], options[:format]) || ["index"], options[:format])
			Page.new(options)
		else
			nil
		end
	end
	
	def initialize(options = {})
		@format = options[:format]
		@content_view = ActionView::Base.new(ActionView::TemplateFinder.process_view_paths(PAGES_ROOT), {:page => self}, self)
		if options[:path] or options[:file_path]
			@path = if options[:file_path]
				Page.file_path_to_path(options[:file_path], @format)
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
		Page.file_path(self.path, self.format)
	end
	
	def dir_path
		Page.dir_path(self.path)
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
	
	def title
		@title || self.path.last.titleize
	end
	
	def children(child_format = self.format)
		@children ||= Dir.glob("#{self.dir_path}/*.#{Page.extension_for_format(child_format)}.erb").collect do |path|
			Page.new(:file_path => path, :format => child_format)
		end
	end
	
	def updated_at
		File.mtime(self.file_path)
	end
	
	def created_at
		File.ctime(self.file_path)
	end
	
	def to_param
		"/" + self.path.join("/")
	end
	
	def new_record?
		!Page.exists?(self.path, self.format)
	end
	
	protected
	
	def self.extension_for_format(format)
		format.to_sym.to_s
	end
	
	def format_extension
		@format_extension ||= Page.extension_for_format(self.format)
	end
end