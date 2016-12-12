require 'thor'
require 'SCTmongo'

module SCTmongo
  class CLI < Thor
  desc "version", "Show current version"
	def version
		puts SCTmongo::VERSION
	end

	des "buildTable", "Generate formal context table"
	def buildTable

	end
	
  end
end