# Rocket-Ruby
Rocket Ruby provides developers (specifically in the Rocket League community) with an easy way to parse important match data from the .replay file format.

To-do list:
  * Convert the metadata to JSON in a nice easy to read way.
  * Fix issues parsing problem replays (outlier cases).

# Requirements
Rocket Ruby uses the [BinData Ruby gem](https://github.com/dmendel/bindata/wiki). Currently there is not a bundled version, so if you plan to use Rocket Ruby you should install the BinData Ruby gem.

# Usage
In order to use Rocket Ruby, all you have to do in include the replay.rb, property.rb and records.rb classes in your working directory.
```ruby
require 'replay.rb'
```
From there, it is very simple to use. Below is a basic implementation where replay_file is a file of the .replay file format. A JSON file can be supplied, or if you need Rocket Ruby to generate its own, just pass nil.
```ruby
# Write to a JSON file (json_file).
myReplay = Replay.new(replay_file, json_file)
myReplay.parse_data

# Create a JSON file.
myReplay = Replay.new(replay_file, nil)
myReplay.parse_data
```

# Installation
I've yet to setup an easy way to install Rocket Ruby yet, but using it is very simple. Just add replay.rb and records.rb into the directory in which you wish to use Rocket Ruby (and make sure to include them in files that use them).

# License
You are free to use Rocket Ruby as you wish. That said, if you do use it, please give me a mention and be sure to let me know so I can check out your project!

# Credits
Big thanks to [tfausak](https://github.com/tfausak) and [danielsamuels](https://github.com/danielsamuels) as I used their works as a guide to reverse engineer the .replay file format.

And of course [Psyonix](http://psyonix.com), the wonderful devs of [Rocket League](http://store.steampowered.com/app/252950/).
