require 'thor'
require 'SCTmongo'

module SCTmongo
  class CLI < Thor
  desc "version", "Show current version"
	def version
		puts ZhSieve::VERSION
	end

  end
end