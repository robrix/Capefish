require "digest/md5"

class BasicUser
	AUTHFILE_PATH = "#{File.dirname(__FILE__)}/../../config/auth.passwd"
	AUTHFILE_ENTRY_PATTERN = /([^\s]+):([^\s]+)/
	
	def self.has_users
		File.exists?(AUTHFILE_PATH)
	end
	
	def self.find(username)
		@user = has_users && username && File.open(AUTHFILE_PATH, "r") do |authfile|
			if password_hash = authfile.detect { |line|
				all, u, password_hash = *(AUTHFILE_ENTRY_PATTERN.match(line))
				RAILS_DEFAULT_LOGGER.info [all, u, password_hash].inspect
				u == username
			}[AUTHFILE_ENTRY_PATTERN, 2] then
				BasicUser.new(:username => username, :password_hash => password_hash)
			end
		end
		RAILS_DEFAULT_LOGGER.info @user.username + " found with hash " + @user.password_hash
		@user
	end
	
	def self.crypt(password)
		Digest::MD5.hexdigest(password)
	end
	
	attr_accessor :username, :password_hash
	
	def initialize(options = {})
		self.username = options[:username]
		self.password_hash = options[:password_hash]
		self.password_hash ||= BasicUser.crypt(options[:password])
	end
	
	def authenticate?(password)
		RAILS_DEFAULT_LOGGER.info BasicUser.crypt(password) + " vs " + self.password_hash
		BasicUser.crypt(password) == self.password_hash
	end
end