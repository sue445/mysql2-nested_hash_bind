# Benchmark report
## [xquery_bench.rb](xquery_bench.rb)
```bash
$ ruby -v
ruby 3.1.2p20 (2022-04-12 revision 4491bb740a) [x86_64-darwin21]

$ bundle exec ruby xquery_bench.rb
Warming up --------------------------------------
Mysql2::Client#xquery
                       248.000  i/100ms
Mysql2::Client#xquery(sql_with_dot) using Mysql2::NestedHashBind::QueryExtension
                       113.000  i/100ms
Mysql2::Client#xquery(sql_without_dot) using Mysql2::NestedHashBind::QueryExtension
                       248.000  i/100ms
Calculating -------------------------------------
Mysql2::Client#xquery
                          3.204k (± 7.2%) i/s -     16.120k in   5.059519s
Mysql2::Client#xquery(sql_with_dot) using Mysql2::NestedHashBind::QueryExtension
                          1.213k (± 3.5%) i/s -      6.102k in   5.038026s
Mysql2::Client#xquery(sql_without_dot) using Mysql2::NestedHashBind::QueryExtension
                          3.171k (± 6.4%) i/s -     15.872k in   5.028264s

Comparison:
Mysql2::Client#xquery:     3204.2 i/s
Mysql2::Client#xquery(sql_without_dot) using Mysql2::NestedHashBind::QueryExtension:     3171.5 i/s - same-ish: difference falls within error
Mysql2::Client#xquery(sql_with_dot) using Mysql2::NestedHashBind::QueryExtension:     1212.7 i/s - 2.64x  (± 0.00) slower
```

## [xquery_stackprof.rb](xquery_stackprof.rb)
### Usage
```bash
bundle exec ruby xquery_stackprof.rb
bundle exec stackprof-webnav -d tmp/
```

open http://localhost:9292/
