## Change Log

### [v2.2.0](https://github.com/khiav223577/multi_range/compare/v1.3.2...v2.2.0) 2023/10/21
- [#34](https://github.com/khiav223577/multi_range/pull/34) Fix: wrong empty range check which causes some differences to be dropped  (@khiav223577)
- [#33](https://github.com/khiav223577/multi_range/pull/33) Fix: result should not be empty when intersection with inclusive range with one element (@khiav223577)
- [#32](https://github.com/khiav223577/multi_range/pull/32) Drop the support of ruby 2.2 (@khiav223577)

### [v2.1.1](https://github.com/khiav223577/multi_range/compare/v2.1.0...v2.1.1) 2021/08/07
- [#26](https://github.com/khiav223577/multi_range/pull/26) Fix: unexpected float value when sample an one-element range (@khiav223577)

### [v2.1.0](https://github.com/khiav223577/multi_range/compare/v2.0.0...v2.1.0) 2021/03/17
- [#24](https://github.com/khiav223577/multi_range/pull/24) Avoid empty sub ranges (@GerritSe)
- [#25](https://github.com/khiav223577/multi_range/pull/25) Do not publish code coverage for PRs from forks (@khiav223577)
- [#22](https://github.com/khiav223577/multi_range/pull/22) Migrating from Travis CI to GitHub Actions (@khiav223577)
- [#21](https://github.com/khiav223577/multi_range/pull/21) Fix: test files should not be included in coverage (@khiav223577)

### [v2.0.0](https://github.com/khiav223577/multi_range/compare/v1.3.0...v2.0.0) 2020/11/19
- [#19](https://github.com/khiav223577/multi_range/pull/19) Implement intersection (@chrisnankervis)
- [#20](https://github.com/khiav223577/multi_range/pull/20) Drop support for Ruby 1.8 and 1.9 (@khiav223577)
- [#17](https://github.com/khiav223577/multi_range/pull/17) Refactoring - increase MAINTAINABILITY (@khiav223577)

### [v1.3.0](https://github.com/khiav223577/multi_range/compare/v1.2.0...v1.3.0) 2020/10/20
- [#16](https://github.com/khiav223577/multi_range/pull/16) Implement contain_overlaps? method (@khiav223577)

### [v1.2.0](https://github.com/khiav223577/multi_range/compare/v1.1.0...v1.2.0) 2020/10/16
- [#15](https://github.com/khiav223577/multi_range/pull/15) Add test cases to test union float ranges (@khiav223577)
- [#14](https://github.com/khiav223577/multi_range/pull/14) Support float ranges (@khiav223577)

### [v1.1.0](https://github.com/khiav223577/multi_range/compare/v1.0.0...v1.1.0) 2020/10/15
- [#13](https://github.com/khiav223577/multi_range/pull/13) Rename flatten => merge_overlaps (@khiav223577)

### [v1.0.0](https://github.com/khiav223577/multi_range/compare/v0.0.4...v1.0.0) 2020/10/15
- [#12](https://github.com/khiav223577/multi_range/pull/12) Implement #overlaps? (@khiav223577)
- [#11](https://github.com/khiav223577/multi_range/pull/11) Support difference other multi_range object (@khiav223577)
- [#10](https://github.com/khiav223577/multi_range/pull/10) Add frozen_string_literal (@khiav223577)
- [#9](https://github.com/khiav223577/multi_range/pull/9) Implement range union (@khiav223577)
- [#8](https://github.com/khiav223577/multi_range/pull/8) Support initializing a MultiRange object with unsorted ranges (@khiav223577)

### [v0.0.4](https://github.com/khiav223577/multi_range/compare/v0.0.3...v0.0.4) 2020/03/26
- [#7](https://github.com/khiav223577/multi_range/pull/7) Add flatten method (@khiav223577)

### [v0.0.3](https://github.com/khiav223577/multi_range/compare/v0.0.2...v0.0.3) 2020/03/02
- [#6](https://github.com/khiav223577/multi_range/pull/6) freeze internal ranges variable (@khiav223577)
- [#5](https://github.com/khiav223577/multi_range/pull/5) Add min, max, to_a method (@khiav223577)

### [v0.0.2](https://github.com/khiav223577/multi_range/compare/v0.0.1...v0.0.2) 2020/03/02
- [#4](https://github.com/khiav223577/multi_range/pull/4) Add each, map, index_with methods (@khiav223577)
- [#3](https://github.com/khiav223577/multi_range/pull/3) Support passing integer as range (@khiav223577)

### v0.0.1 2020/03/01
- [#2](https://github.com/khiav223577/multi_range/pull/2) Support Ruby 1.8.7 (@khiav223577)
- [#1](https://github.com/khiav223577/multi_range/pull/1) Implement MultiRange (@khiav223577)
