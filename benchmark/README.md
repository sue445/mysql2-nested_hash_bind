# Benchmark report
## [xquery_bench.rb](xquery_bench.rb)
```bash
$ ruby -v
ruby 3.1.2p20 (2022-04-12 revision 4491bb740a) [x86_64-darwin21]

$ bundle exec ruby xquery_bench.rb
============== Benchmark with LIMIT 10 ==============
Warming up --------------------------------------
Mysql2::Client#xquery
                       545.000  i/100ms
Mysql2::Client#xquery(sql_with_dot) using Mysql2::NestedHashBind::QueryExtension
                       128.000  i/100ms
Mysql2::Client#xquery(sql_without_dot) using Mysql2::NestedHashBind::QueryExtension
                       297.000  i/100ms
Calculating -------------------------------------
Mysql2::Client#xquery
                          6.297k (± 8.4%) i/s -     31.610k in   5.070376s
Mysql2::Client#xquery(sql_with_dot) using Mysql2::NestedHashBind::QueryExtension
                          4.420k (±17.4%) i/s -     20.992k in   5.017688s
Mysql2::Client#xquery(sql_without_dot) using Mysql2::NestedHashBind::QueryExtension
                          4.460k (±31.2%) i/s -     19.602k in   5.004246s

Comparison:
Mysql2::Client#xquery:     6296.7 i/s
Mysql2::Client#xquery(sql_without_dot) using Mysql2::NestedHashBind::QueryExtension:     4460.4 i/s - same-ish: difference falls within error
Mysql2::Client#xquery(sql_with_dot) using Mysql2::NestedHashBind::QueryExtension:     4419.7 i/s - 1.42x  (± 0.00) slower

============== Benchmark with LIMIT 100 ==============
Warming up --------------------------------------
Mysql2::Client#xquery
                       201.000  i/100ms
Mysql2::Client#xquery(sql_with_dot) using Mysql2::NestedHashBind::QueryExtension
                        81.000  i/100ms
Mysql2::Client#xquery(sql_without_dot) using Mysql2::NestedHashBind::QueryExtension
                       122.000  i/100ms
Calculating -------------------------------------
Mysql2::Client#xquery
                          2.377k (±28.2%) i/s -     10.653k in   5.071173s
Mysql2::Client#xquery(sql_with_dot) using Mysql2::NestedHashBind::QueryExtension
                        978.170  (±20.9%) i/s -      4.617k in   5.050665s
Mysql2::Client#xquery(sql_without_dot) using Mysql2::NestedHashBind::QueryExtension
                          2.745k (±21.0%) i/s -     12.810k in   5.006464s

Comparison:
Mysql2::Client#xquery(sql_without_dot) using Mysql2::NestedHashBind::QueryExtension:     2744.6 i/s
Mysql2::Client#xquery:     2376.9 i/s - same-ish: difference falls within error
Mysql2::Client#xquery(sql_with_dot) using Mysql2::NestedHashBind::QueryExtension:      978.2 i/s - 2.81x  (± 0.00) slower
```

## [xquery_stackprof.rb](xquery_stackprof.rb)
### Usage
```bash
bundle exec ruby xquery_stackprof.rb
bundle exec stackprof-webnav -d tmp/
```

open http://localhost:9292/
