# frozen_string_literal: true

require_relative "network"

module Airport
  # A basic package available on Paper's Hangar plugin system.
  class PaperPackage
    # An error thrown when a version of a package isn't found.
    class NoPackageVersionFound < StandardError; end

    # An error thrown when the package data (i.e., JAR)
    class NoPackageDataFound < StandardError; end

    attr_accessor :name

    def initialize(pkgname, filename, pinned_version = nil)
      @name = pkgname
      @filepath = filename
      @pinned = pinned_version unless pinned_version.nil?
      @service = Airport::Hangar.new
    end

    def version
      return @pinned unless @pinned.nil?

      response = @service.request "/projects/#{@name}/latestrelease"
      response.body unless response.is_a?(Net::HTTPError)
    end

    def installed?
      File.exist? @filepath
    end

    def fetch(ver = nil)
      ver_to_download = ver.nil? ? version : ver
      raise NoPackageVersionFound if ver_to_download.nil?

      ver_string = /([\d.]+)/.match?(ver_to_download) ? ver_to_download : 'latest'
      puts "\x1b[1;92mInstalling\x1b[0m #{@name} (#{ver_string})"

      pkgdata = @service.request "/projects/#{@name}/versions/#{ver_to_download}/PAPER/download"
      raise NoPackageDataFound if pkgdata.body.nil?

      File.open(@filepath, 'w+') do |file|
        file.write pkgdata.body
      end
    end
  end
end
