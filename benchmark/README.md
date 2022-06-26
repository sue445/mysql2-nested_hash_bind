# Benchmark report
## [xquery_bench.rb](xquery_bench.rb)
```bash
$ ruby -v
ruby 3.1.2p20 (2022-04-12 revision 4491bb740a) [x86_64-darwin21]

$ bundle exec ruby xquery_bench.rb
============== Benchmark with LIMIT 10 ==============
Warming up --------------------------------------
Mysql2::Client#xquery
                       281.000  i/100ms
Mysql2::Client#xquery(sql_with_dot) using Mysql2::NestedHashBind::QueryExtension
                       310.000  i/100ms
Mysql2::Client#xquery(sql_without_dot) using Mysql2::NestedHashBind::QueryExtension
                       586.000  i/100ms
Calculating -------------------------------------
Mysql2::Client#xquery
                          6.219k (±12.2%) i/s -     30.629k in   5.032290s
Mysql2::Client#xquery(sql_with_dot) using Mysql2::NestedHashBind::QueryExtension
                          4.687k (±10.4%) i/s -     23.250k in   5.045175s
Mysql2::Client#xquery(sql_without_dot) using Mysql2::NestedHashBind::QueryExtension
                          4.394k (±29.4%) i/s -     19.924k in   5.046162s

Comparison:
Mysql2::Client#xquery:     6218.6 i/s
Mysql2::Client#xquery(sql_with_dot) using Mysql2::NestedHashBind::QueryExtension:     4687.5 i/s - 1.33x  (± 0.00) slower
Mysql2::Client#xquery(sql_without_dot) using Mysql2::NestedHashBind::QueryExtension:     4393.6 i/s - same-ish: difference falls within error

============== Benchmark with LIMIT 100 ==============
Warming up --------------------------------------
Mysql2::Client#xquery
                       314.000  i/100ms
Mysql2::Client#xquery(sql_with_dot) using Mysql2::NestedHashBind::QueryExtension
                       102.000  i/100ms
Mysql2::Client#xquery(sql_without_dot) using Mysql2::NestedHashBind::QueryExtension
                       228.000  i/100ms
Calculating -------------------------------------
Mysql2::Client#xquery
                          3.082k (±11.0%) i/s -     15.386k in   5.079376s
Mysql2::Client#xquery(sql_with_dot) using Mysql2::NestedHashBind::QueryExtension
                          1.084k (±10.2%) i/s -      5.406k in   5.049159s
Mysql2::Client#xquery(sql_without_dot) using Mysql2::NestedHashBind::QueryExtension
                          3.150k (± 5.1%) i/s -     15.732k in   5.008413s

Comparison:
Mysql2::Client#xquery(sql_without_dot) using Mysql2::NestedHashBind::QueryExtension:     3150.1 i/s
Mysql2::Client#xquery:     3081.9 i/s - same-ish: difference falls within error
Mysql2::Client#xquery(sql_with_dot) using Mysql2::NestedHashBind::QueryExtension:     1083.7 i/s - 2.91x  (± 0.00) slower
```

## [xquery_stackprof.rb](xquery_stackprof.rb)
### Usage
```bash
bundle exec ruby xquery_stackprof.rb
bundle exec stackprof-webnav -d tmp/
```

open http://localhost:9292/
