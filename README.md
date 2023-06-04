# AutoEQ::Loader

This is a Ruby gem that works with the collection of headphone equalizations generated by the [AutoEQ](https://autoeq.app) project. With the gem, you can load the full set of equalizations, find one or more equalizations by name, and generate **audio filter** strings. These strings can then be used with projects like [MPV](https://mpv.io), [FFmpeg](https://ffmpeg.org), or other projects that use [libavfilter](https://ffmpeg.org/libavfilter.html) to process audio. Canonical information about filters can be found at [FFmpeg Filters Documentation](https://ffmpeg.org/ffmpeg-filters.html).

You will need to have AutoEQ's `results` directory stored somewhere on your system. You can get it by cloning the [AutoEQ Git repository](https://github.com/jaakkopasanen/AutoEq) or by downloading one of the [releases](https://github.com/jaakkopasanen/AutoEq/tags). Then you will find the `results` directory in the top level. Consult the [README file](https://github.com/jaakkopasanen/AutoEq/blob/master/results/README.md) there for details on the results.

This gem uses the `ParametricEQ.txt` files from the `results` directory, each of which contain:

- A relative volume (aka 'preamp') to adjust the audio, to compensate for equalizations that effectively change the overall volume.
- One or more EQ filters that describe the type, frequency, gain, and width of a particular equalization to apply.

The `load_equalizers` class method returns an array of equalizers found in the specified directory, each of which has a name derived from the filename. There's no attempt to interpret or modify the names, so it's best to consult the original files if you're unsure of the naming conventions.

An equalizer is converted to an audio filter string simply by calling its `#to_s` method, or by interpreting it a string context that will implicitly call `#to_s`. A filter string looks like this:

```
volume=-3.8dB,equalizer=f=105:g=1.4:w=0.7:t=q,equalizer=f=8313:g=2.9:w=1.52:t=q,equalizer=f=126:g=-2.0:w=0.83:t=q,equalizer=f=3198:g=3.4:w=2.66:t=q,equalizer=f=2019:g=-2.0:w=1.8:t=q,equalizer=f=10000:g=-5.2:w=0.7:t=q,equalizer=f=529:g=-1.0:w=1.59:t=q,equalizer=f=1042:g=1.1:w=2.59:t=q,equalizer=f=5337:g=-1.5:w=4.59:t=q,equalizer=f=6646:g=2.8:w=5.93:t=q
```

The actual EQ file for each equalizer is loaded lazily, only when the `#to_s` method is called.

The `#to_s` method has one optional parameter: a boolean to indicate whether the equalizer should be enabled or not. If enabled (the default), then both a volume filter and an equalizer filter is returned. If disabled, only the volume filter is returned. This is to handle cases where an equalizer may be toggled off or on, but maintain the overall volume level.


## Installation

Install the gem and add to your application's `Gemfile` by executing:

    $ bundle add autoeq_loader

If Bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install autoeq_loader


## Usage

```ruby
require 'autoeq_loader'

# load the equalizers
equalizers = AutoEQLoader.load_equalizers('~/src/AutoEQ/results')

# find an equalizer for the FiiO FH7 headphones
eq = equalizers.find { |e| e.name =~ /fh7/i }

# show its name
puts eq.name

# run MPV with the filter
system(
  'mpv',
  "--af=#{eq.to_s}",
  'my-music-file.mp4')
```

See the [`examples`](examples) directory for more.


## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake test` to run the tests.

To release a new version, update the version number in `autoeq-loader.gemspec`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jslabovitz/autoeq_loader.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).