class AutoEQLoader

  attr_reader :name

  def self.load_equalizers(dir)
    dir = File.expand_path(dir)
    Dir.glob('**/*ParametricEQ.txt', base: dir, sort: false).map do |file|
      new(File.join(dir, file))
    end.sort
  end

  def initialize(file)
    @file = file
    @name = File.basename(File.dirname(file))
    @volume_filter = @equalizer_filters = nil
  end

  def load
    @volume_filter = VolumeFilter.new(0.0)
    @equalizer_filters = []
    File.open(@file) do |io|
      io.readlines.map { |l| l.sub(/#.*/, '') }.map(&:strip).reject(&:empty?).each do |line|
        case line
        when /^Preamp: ([-.\d]+) dB$/
          @volume_filter = VolumeFilter.new($1.to_f)
        when /^Filter \d+: ON .+? Fc (\d+) Hz Gain ([-.\d]+) dB Q ([-.\d]+)$/
          @equalizer_filters << ParametricEqualizerFilter.new($1.to_i, $2.to_f, $3.to_f, 'q')
        else
          warn "#{@file}: Ignoring unknown eq line: #{line.inspect}"
        end
      end
    end
  end

  def <=>(other)
    @name <=> other.name
  end

  def to_s(enabled=true)
    load unless @volume_filter
    [
      @volume_filter,
      enabled ? @equalizer_filters : nil,
    ].flatten.compact.map(&:to_s).join(',')
  end

  class VolumeFilter < Struct.new(:volume)

    def to_s
      "volume=#{volume}dB"
    end

  end

  class ParametricEqualizerFilter < Struct.new(:f, :g, :w, :t)

    def to_s
      "equalizer=%s" % %w[f g w t].map { |k| '%s=%s' % [k, send(k)] }.join(':')
    end

  end

end