$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'minitest/autorun'
require 'minitest/power_assert'

require 'autoeq_loader'

class AutoEQLoader

  class Test < MiniTest::Test

    SourceDir = '~/src/AutoEQ/results'

    def setup
      @equalizers = AutoEQLoader.load_equalizers(SourceDir)
      @eq = @equalizers.find { |e| e.name =~ /fh7/i }
    end

    def test_load
      assert { @equalizers }
      assert { !@equalizers.empty? }
    end

    def test_find
      assert { @eq }
      assert { @eq.name == 'FiiO FH7' }
    end

    def test_enabled
      assert { @eq }
      filter = @eq.to_s
      assert { filter =~ /^volume=[\-\.\d+]+dB,equalizer=f/ }
    end

    def test_disabled
      assert { @eq }
      filter = @eq.to_s(false)
      assert { filter =~ /^volume=[\-\.\d+]+dB$/ }
    end

    def test_load_all
      @equalizers.map(&:load)
    end

  end

end