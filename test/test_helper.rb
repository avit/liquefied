$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'liquefied'

require 'minitest/autorun'

class TimeObject
  def initialize(value)
    @value = value
  end

  def +(offset)
    TimeObject.new(@value + offset)
  end

  def sec
    @value.sec
  end

  def to_s(format=nil)
    case format
    when :short
      @value.strftime("%H:%M:%S")
    else
      @value.to_s
    end
  end
end

class StringObject
  def initialize(value)
    @value = value
  end

  def to_s
    @value
  end
end
