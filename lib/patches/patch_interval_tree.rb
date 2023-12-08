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
        s_center.select do |range|
          # when this range is smaller than and not overlaps with `query`
          #      range          query
          #   |---------|    |---------|
          if query.begin and range.end
            next false if query.begin > range.end
            next false if query.begin == range.end and range.exclude_end?
          end

          # when this range is larger than and not overlaps with `query`
          #      query          range
          #   |---------|    |---------|
          if query.end and range.begin
            next false if query.end < range.begin
            next false if query.end == range.begin and query.exclude_end?
          end

          next true
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
