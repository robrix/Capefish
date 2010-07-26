module Capefish
  class	Page
    attr_accessor :content, :raw_content, :summary
  	attr_accessor :title, :path
  	attr_accessor :layout_template, :content_template
  
  	class PageNotFoundException < Exception ; end
	
  	PAGES_ROOT = "#{Rails.root}/pages"
  	CONTENT_TEMPLATE_ROOT = "#{Rails.root}/app/views"
  	CAPEFISH_CONTENT_TEMPLATE_ROOT = "#{Rails.root}/vendor/plugins/capefish/app/views"
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
	
  	def self.roots
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
  		@content_view = ActionView::Base.new(ActionView::Base.process_view_paths(PAGES_ROOT), {:page => self}, self)
  		@content_template_view = ActionView::Base.new(ActionView::Base.process_view_paths([CONTENT_TEMPLATE_ROOT, CAPEFISH_CONTENT_TEMPLATE_ROOT]), {:page => self}, self)
  		if options[:path] or options[:file_path]
  			@path = if options[:file_path]
  				Page.file_path_to_path(options[:file_path])
  			else
  				options[:path]
  			end
  		else
  			@path = ["index"]
  		end
  		@content_template = "default"
  		_content = self.content
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
  		@content ||= @content_view.render(:file => self.path.join("/"))
  	end
	
  	def templated_content
  		_content = self.content
      @content_template_view.render(:partial => "layouts/#{self.content_template}", :page => self)
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
  		@name ||= self.path.last
  	end
	
  	def title
  		@title ||= self.name.titleize
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
  		self.id
  	end
	
  	def new_record?
  		!Page.exists?(self.path)
  	end
	
  	def id
  		self.path.join("%2F")
  	end
	
  	def to_link
  		self.path.join("/")
  	end
	
	
  	def private?
  	  @private
  	end
	
  	def private=(flag)
  	  @private = flag
    end
  end
end
