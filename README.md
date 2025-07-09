# Airport 🛃

**Airport** is a small Ruby program that lets you install plugins for your
PaperMC server from the [Hangar](https://hangar.papermc.io) service easily
with a simple configuration file. It is designed to be lightweight and
easy to use and deploy to servers.

> **Important**  
> This command line tool is still a work in progress. Expect breaking
> or untested changes!

## Getting started

**Required**

- Ruby (at least v3.1.0)

Start by cloning this repository with `git clone`, then run the following:

```
gem install bundler
bundle install
rake install
```

Then, in your Paper server directory, run `airport init`. A new termspec
file will be created!

## Configuring Airport

Airport uses a simple termspec file to configure the Paper installation
and plugins that you'd like to install or update. Termspec files are Ruby
scripts that define a `TerminalGate` which is used to perform actions in
Airport. See below for an example:

```ruby
Airport::TerminalGate.new do
    # Point to where your Paper server is.
    paper '/opt/paper'
    
    # Define the plugins you want to install. Optionally, you can provide
    # a specific pinned version to install. Plugin entries that don't
    # specify a version will automatically pull the latest version
    # available from Hangar's servers.
    plugin 'geyser'
    plugin 'floodgate'
    
    plugin 'gsit', '2.4.0'
end
```

## Available Commands

- **init**: Creates a new termspec file at the path you specify.
- **install**: Installs plugins defined in the termspec.
- **refresh**: Installs plugins defined in the termspec, skipping any
  plugins that are already installed (great for just adding new plugins).
- **update**: Downloads the latest versions of plugins from Hangar and
  places them in the `plugins/update` folder.
  
> **Info**  
> When running `airport update`, plugins are placed in the `update` folder
> and use Paper's plugin update system to apply the changes on the next
> server restart.
>
> [Learn more &rsaquo;](https://docs.papermc.io/paper/updating/#step-2-update-plugins)

Each of the commands above support the `-f` or `--file` option to point to
a specific termspec file. By default, if this option isn't provided, it
will attempt to use the local `.termspec` from where you run the tool.

## License

Airport is free and open-source software licensed under the Mozilla Public
License, v2.0. For more information on your rights, refer to the
LICENSE.txt file attached in this repository, or visit
http://mozilla.org/MPL/2.0/.
