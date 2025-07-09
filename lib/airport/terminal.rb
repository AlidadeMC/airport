# frozen_string_literal: true

require 'fileutils'
require_relative 'paperpkg'

module Airport
  # Foobar
  class TerminalGate
    # Foobar
    class SimplePlugin
      attr_accessor :name, :version

      def initialize(name, version = nil)
        @name = name
        @version = version
      end
    end

    attr_accessor :plugins, :paper_path

    def initialize(&block)
      @paper_path = ''
      @plugins = []
      instance_eval(&block) if block_given?
    end

    def paper(path)
      @paper_path = path
    end

    def plugin(name, version = nil)
      @plugins << SimplePlugin.new(name, version)
    end
  end

  # Foobar
  class Terminal
    def initialize(gate)
      @gate = gate
    end

    def path_exists?
      !@gate.paper_path.nil? && @gate.paper_path != ''
    end

    def install_plugins
      unless path_exists?
        warn 'Skipping plugin install because the Paper path is missing.'
        return
      end
      @gate.plugins.each do |plugin|
        install_plugin(plugin)
      end
    end

    def refresh_plugins
      unless path_exists?
        warn 'Skipping plugin refresh because the Paper path is missing.'
        return
      end
      @gate.plugins.each do |plugin|
        install_plugin(plugin, 'plugins', skip_installed: true)
      end
    end

    def update_plugins
      unless path_exists?
        warn 'Skipping plugin update because the Paper path is missing.'
        return
      end
      FileUtils.mkdir_p "#{@gate.paper_path}/plugins/update"
      @gate.plugins.each do |plugin|
        install_plugin(plugin, 'plugins/update')
      end
    end

    def install_plugin(plugin, subpath = 'plugins', skip_installed: false)
      pkg = Airport::PaperPackage.new(
        plugin.name,
        "#{@gate.paper_path}/#{subpath}/#{plugin.name}.jar",
        plugin.version
      )
      return if pkg.installed? && skip_installed

      pkg.fetch
    end
  end
end
