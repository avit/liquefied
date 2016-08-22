require 'test_helper'

class LiquefiedTest < Minitest::Test

  def test_that_it_has_a_version_number
    refute_nil ::Liquefied::VERSION
  end

  def test_liquefied_class
    value = Liquefied.new("x")

    assert_equal String, value.class
  end

  def test_finalize_no_arguments
    value = Liquefied.new(time)

    assert_equal '2016-01-01 12:34:56 UTC', value.to_s
  end

  def test_finalize_one_default_argument
    value = Liquefied.new(time, :short)

    assert_equal '12:34:56', value.to_s
  end

  def test_finalize_specified_argument
    value = Liquefied.new(time)

    assert_equal '12:34:56', value.to_s(:short)
  end

  def test_delegate_same_type_stays_wrapped
    value = Liquefied.new(time, :short)
    value = value + 4

    assert_equal '12:35:00', value.to_s
  end

  def test_delegate_different_type
    value = Liquefied.new(time)

    assert_equal 56, value.sec
  end

  def test_implicit_conversion
    value = Liquefied.new(time, :short)
    result = "<%s>" % value

    assert_equal '<12:34:56>', result
  end

  def test_number_conversion_block
    value = Liquefied.new(12.33333) { |i, *args|
      cents = args[0] || 2
      "$%.#{cents}f" % i
    }

    assert_equal "$12.33", value.to_s
    assert_equal "$12",    value.to_s(0)
    assert_equal "12",     value.to_s { |v, *args| v.round.to_s }
  end

  def test_time_conversion_block
    value = Liquefied.new(time, :short) { |i, *args|
      args.any? ? i.to_s(*args) : "<time>#{i.to_s(*args)}</time>"
    }

    assert_equal "<time>2016-01-01 12:34:56 UTC</time>", value.to_s
    assert_equal "12:34:56", value.to_s(:short)
    assert_equal "*12:34:56*", value.to_s { |t| "*#{t.to_s(:short)}*" }
  end

  def test_string_wrapper_without_to_str_supports_explicit_conversion
    value = Liquefied.new(StringObject.new("abcdef"))
    assert_equal 'abcdef', value.to_str
  end

  def test_string_finalizes_to_str_as_implicit_conversion
    value = Liquefied.new("abcdef", method: :to_str)
    assert_equal 'abcdef', "#{value}"
  end

  def test_multiple_finalizer_aliases
    value = Liquefied.new(time, method: [:to_s, :to_json]) { "[12, 34, 56]" }
    assert_equal '[12, 34, 56]', value.to_json
  end

  private

  def time
    TimeObject.new(Time.utc(2016,1,1,12,34,56))
  end

end
