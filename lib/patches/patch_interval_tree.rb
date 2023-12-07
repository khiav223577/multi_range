module Patches
  module PatchIntervalTree
    module ForTree
      def divide_intervals(intervals)
        return nil if intervals.empty?
        x_center = center(intervals)
        s_center = []
        s_left = []
        s_right = []

        intervals.each do |k|
          case
          when k.end && k.end != Float::INFINITY && k.end.to_r < x_center
            s_left << k
          when k.begin && k.begin.to_r > x_center
            s_right << k
          else
            s_center << k
          end
        end

        IntervalTree::Node.new(x_center, s_center, divide_intervals(s_left), divide_intervals(s_right))
      end

      def search(query, options = {})
        options = IntervalTree::Tree::DEFAULT_OPTIONS.merge(options)

        return nil unless @top_node

        if query.respond_to?(:first)
          result = top_node.search(query)
          options[:unique] ? result.uniq : result
        else
          point_search(top_node, query, [], options[:unique])
        end
          .sort_by{|x| [x.begin || -Float::INFINITY, x.end || Float::INFINITY] }
      end

      private

      def ensure_exclusive_end(ranges, range_factory)
        ranges.map do |range|
          case
          when !range.respond_to?(:exclude_end?)
            range
          when range.exclude_end?
            range
          else
            range_factory.call(range.begin, range.end)
          end
        end
      end

      def center(intervals)
        min_val = intervals.map(&:begin).compact.min
        max_val = intervals.map(&:end).compact.max
        return min_val * 2 if max_val == nil
        return max_val / 2 if min_val == nil
        return (min_val.to_r + max_val.to_r) / 2
      end
    end

    module ForNode
      def search_s_center(query)
        s_center.select do |k|
          begin_is_larger = k.begin && k.begin >= query.begin
          end_is_smaller = k.end && k.end != Float::INFINITY && k.end <= query.end
          (
            # k is entirely contained within the query
            begin_is_larger && end_is_smaller
          ) || (
            # k's start overlaps with the query
            begin_is_larger && (k.begin && k.begin < query.end)
          ) || (
            # k's end overlaps with the query
            (k.end && k.end > query.begin) && (end_is_smaller)
          ) || (
            # k is bigger than the query
            (k.begin && k.begin < query.begin) && (k.end && k.end > query.end)
          )
        end
      end
    end
  end
end

module IntervalTree
  class Tree
    prepend Patches::PatchIntervalTree::ForTree
  end

  class Node
    prepend Patches::PatchIntervalTree::ForNode
  end
end
