# Benchmark report
## [xquery_bench.rb](xquery_bench.rb)
```bash
$ ruby -v
ruby 3.1.2p20 (2022-04-12 revision 4491bb740a) [x86_64-darwin21]

$ bundle exec ruby xquery_bench.rb
Warming up --------------------------------------
Mysql2::Client#xquery
                       708.000  i/100ms
Mysql2::Client#xquery(sql_with_dot) using Mysql2::NestedHashBind::QueryExtension
                       109.000  i/100ms
Mysql2::Client#xquery(sql_without_dot) using Mysql2::NestedHashBind::QueryExtension
                       700.000  i/100ms
Calculating -------------------------------------
Mysql2::Client#xquery
                          7.141k (± 1.7%) i/s -     36.108k in   5.057966s
Mysql2::Client#xquery(sql_with_dot) using Mysql2::NestedHashBind::QueryExtension
                        924.255  (±55.2%) i/s -      3.815k in   5.050605s
Mysql2::Client#xquery(sql_without_dot) using Mysql2::NestedHashBind::QueryExtension
                          6.919k (± 5.0%) i/s -     35.000k in   5.073983s
```

## [xquery_stackprof.rb](xquery_stackprof.rb)
### Usage
```bash
bundle exec ruby xquery_stackprof.rb
bundle exec stackprof-webnav -d tmp/
```

open http://localhost:9292/
