# frozen_string_literal: true

require 'fileutils'
require_relative 'paperpkg'

module Airport
  # A configuration class used to configure the main terminal.
  class TerminalGate
    # A representation of a simple plugin with a name and version.
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

    # Sets the path to the PaperMC server to manage.
    def paper(path)
      @paper_path = path
    end

    # Specifies a plugin that should be installed or managed by the airport
    # terminal.
    def plugin(name, version = nil)
      @plugins << SimplePlugin.new(name, version)
    end
  end

  # The main interface for installing and updating plugins.
  class Terminal
    def initialize(gate)
      @gate = gate
    end

    # Reports whether the PaperMC server path exists.
    def path_exists?
      !@gate.paper_path.nil? && @gate.paper_path != ''
    end

    # Installs all plugins defined in the configuration.
    def install_plugins
      unless path_exists?
        warn 'Skipping plugin install because the Paper path is missing.'
        return
      end
      @gate.plugins.each do |plugin|
        install_plugin(plugin)
      end
    end

    # Installs all plugins defined in the configuration, skipping over any
    # plugins that are already installed.
    #
    # This is typically used to install plugins that were recently added
    # to the terminal gate.
    def refresh_plugins
      unless path_exists?
        warn 'Skipping plugin refresh because the Paper path is missing.'
        return
      end
      @gate.plugins.each do |plugin|
        install_plugin(plugin, 'plugins', skip_installed: true)
      end
    end

    # Update all plugins defined in the configuration.
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

    private

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
