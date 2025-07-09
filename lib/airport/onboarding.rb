# frozen_string_literal: true

TEMPLATE = <<~TEMPLATE
  Airport::TerminalGate.new do
    # Define where your Paper installation is.
    paper '/opt/paper'

    # Specify the plugins you'd like to have installed on your server here,
    # optionally with a specific version.
    plugin 'geyser'
    plugin 'floodgate'
  end
TEMPLATE

# Creates a template termspec file at the specified file path.
def write_template(path = '.termspec')
  File.open(path, 'w') do |file|
    file.write TEMPLATE
  end
end
