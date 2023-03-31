# frozen_string_literal: true

require 'test_helper'

class ContainOverlapTest < Minitest::Test
  def setup
  end

  def test_empty_range
    assert_equal false, MultiRange.new([]).contain_overlaps?
  end

  def test_when_have_only_one_range
    assert_equal false, MultiRange.new([-9999, 9999]).contain_overlaps?
  end

  def test_when_range_have_excluded_right_value
    assert_equal false, MultiRange.new([0...5, 5..10, 20..50]).contain_overlaps?
    assert_equal true, MultiRange.new([0..5, 5..10, 20..50]).contain_overlaps?
  end

  def test_when_full_cover_excluded_range
    assert_equal true, MultiRange.new([0...360, 50..120]).contain_overlaps?
  end

  def test_when_right_cover_excluded_range
    assert_equal true, MultiRange.new([0...360, -10..20]).contain_overlaps?
  end

  def test_when_left_cover_excluded_range
    assert_equal true, MultiRange.new([0...360, 330..400]).contain_overlaps?
  end

  def test_when_not_cover_excluded_range
    assert_equal true, MultiRange.new([0...360, -30..400]).contain_overlaps?
  end

  def test_float
    assert_equal false, MultiRange.new([1.2..1.5, 1.7..1.8, 3.5..7.2, 1.6..1.65]).contain_overlaps?
    assert_equal false, MultiRange.new([1.2..1.5, 1.7..1.8, 3.5..7.2, 1.6..1.69]).contain_overlaps?
    assert_equal false, MultiRange.new([1.2..1.5, 1.7..1.8, 3.5..7.2, 1.6...1.7]).contain_overlaps?
    assert_equal true, MultiRange.new([1.2..1.5, 1.7..1.8, 3.5..7.2, 1.6..1.7]).contain_overlaps?
    assert_equal true, MultiRange.new([1.2..1.5, 1.7..1.8, 3.5..7.2, 1.6..1.71]).contain_overlaps?

    val = 1.7 - Float::EPSILON
    assert_equal false, MultiRange.new([1.2..1.5, 1.7..1.8, 3.5..7.2, 1.6...val]).contain_overlaps?
    assert_equal false, MultiRange.new([1.2..1.5, 1.7..1.8, 3.5..7.2, 1.6..val]).contain_overlaps?
  end

  def test_date
    assert_equal false, MultiRange.new([Date.new(2001,2,3)..Date.new(2001,3,10), Date.new(2002,2,3)..Date.new(2002,3,10)]).contain_overlaps?
    assert_equal true, MultiRange.new([Date.new(2001,2,3)..Date.new(2002,3,10), Date.new(2002,3,3)..Date.new(2002,3,10)]).contain_overlaps?
    assert_equal true, MultiRange.new([Date.new(2001,2,3)..Date.new(2002,3,10), Date.new(2002,3,4)..Date.new(2002,3,10)]).contain_overlaps?
  end

  def test_time_overlaps
    assert_equal false, MultiRange.new(
                   [
                     Time.at(0)..Time.at(1),
                     Time.at(3)..Time.at(4)
                   ]
                 ).contain_overlaps?

    assert_equal false, MultiRange.new(
                   [
                     Time.at(0)..Time.at(1),
                     Time.at(2)..Time.at(4)
                   ]
                 ).contain_overlaps?

    assert_equal true, MultiRange.new(
                   [
                     Time.at(0)..Time.at(1),
                     Time.at(1)..Time.at(4)
                   ]
                 ).contain_overlaps?

    assert_equal true, MultiRange.new(
                   [
                     Time.at(0)..Time.at(1, 500, :nsec),
                     Time.at(1,999,:nsec)..Time.at(4)
                   ]
                 ).contain_overlaps?

    assert_equal true, MultiRange.new(
                   [
                     Time.at(0)..Time.at(1, 500, :nsec),
                     Time.at(1,1499,:nsec)..Time.at(4)
                   ]
                 ).contain_overlaps?

    assert_equal false, MultiRange.new(
                   [
                     Time.at(0)..Time.at(1, 499, :nsec),
                     Time.at(1,999,:nsec)..Time.at(4)
                   ]
                 ).contain_overlaps?

    assert_equal false, MultiRange.new(
                   [
                     Time.at(0)..Time.at(1),
                     Time.at(1,500,:nsec)..Time.at(4)
                   ]
                 ).contain_overlaps?

    assert_equal false, MultiRange.new(
                   [
                     Time.at(0)..Time.at(1),
                     Time.at(1,1499,:nsec)..Time.at(4)
                   ]
                 ).contain_overlaps?

    assert_equal false, MultiRange.new(
                   [
                     Time.at(0)..Time.at(1),
                     Time.at(1,1,:microsecond)..Time.at(4)
                   ]
                 ).contain_overlaps?

    assert_equal false, MultiRange.new(
                   [
                     Time.at(0)..Time.at(1),
                     Time.at(1,1,:millisecond)..Time.at(4)
                   ]
                 ).contain_overlaps?
  end

  def test_active_support_time_with_timezone_overlaps
    require 'active_support/time_with_zone'
    require 'active_support/time'
    Time.zone = 'Eastern Time (US & Canada)'

    assert_equal false, MultiRange.new(
                   [
                     Time.zone.at(0)..Time.zone.at(1),
                     Time.zone.at(3)..Time.zone.at(4)
                   ]
                 ).contain_overlaps?

    assert_equal false, MultiRange.new(
                   [
                     Time.zone.at(0)..Time.zone.at(1),
                     Time.zone.at(2)..Time.zone.at(4)
                   ]
                 ).contain_overlaps?

    assert_equal true, MultiRange.new(
                   [
                     Time.zone.at(0)..Time.zone.at(1),
                     Time.zone.at(1)..Time.zone.at(4)
                   ]
                 ).contain_overlaps?

    assert_equal true, MultiRange.new(
                   [
                     Time.zone.at(0)..Time.zone.at(1, 500, :nsec),
                     Time.zone.at(1,999,:nsec)..Time.zone.at(4)
                   ]
                 ).contain_overlaps?

    assert_equal true, MultiRange.new(
                   [
                     Time.zone.at(0)..Time.zone.at(1, 500, :nsec),
                     Time.zone.at(1,1499,:nsec)..Time.zone.at(4)
                   ]
                 ).contain_overlaps?

    assert_equal false, MultiRange.new(
                   [
                     Time.zone.at(0)..Time.zone.at(1, 499, :nsec),
                     Time.zone.at(1,999,:nsec)..Time.zone.at(4)
                   ]
                 ).contain_overlaps?

    assert_equal false, MultiRange.new(
                   [
                     Time.zone.at(0)..Time.zone.at(1),
                     Time.zone.at(1,500,:nsec)..Time.zone.at(4)
                   ]
                 ).contain_overlaps?

    assert_equal false, MultiRange.new(
                   [
                     Time.zone.at(0)..Time.zone.at(1),
                     Time.zone.at(1,1499,:nsec)..Time.zone.at(4)
                   ]
                 ).contain_overlaps?

    assert_equal false, MultiRange.new(
                   [
                     Time.zone.at(0)..Time.zone.at(1),
                     Time.zone.at(1,1,:microsecond)..Time.zone.at(4)
                   ]
                 ).contain_overlaps?

    assert_equal false, MultiRange.new(
                   [
                     Time.zone.at(0)..Time.zone.at(1),
                     Time.zone.at(1,1,:millisecond)..Time.zone.at(4)
                   ]
                 ).contain_overlaps?
  end
end
