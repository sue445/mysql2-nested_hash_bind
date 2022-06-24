# Benchmark report
## [xquery_bench.rb](xquery_bench.rb)
```bash
$ ruby -v
ruby 3.1.2p20 (2022-04-12 revision 4491bb740a) [x86_64-darwin21]

$ bundle exec ruby xquery_bench.rb
Warming up --------------------------------------
Mysql2::Client#xquery
                       694.000  i/100ms
Mysql2::Client#xquery(sql_with_dot) using Mysql2::NestedHashBind::QueryExtension
                       102.000  i/100ms
Mysql2::Client#xquery(sql_without_dot) using Mysql2::NestedHashBind::QueryExtension
                       183.000  i/100ms
Calculating -------------------------------------
Mysql2::Client#xquery
                          7.148k (± 4.3%) i/s -     36.088k in   5.061558s
Mysql2::Client#xquery(sql_with_dot) using Mysql2::NestedHashBind::QueryExtension
                        980.516  (±52.5%) i/s -      4.080k in   5.047444s
Mysql2::Client#xquery(sql_without_dot) using Mysql2::NestedHashBind::QueryExtension
                          7.028k (± 4.5%) i/s -     35.136k in   5.022360s
```

## [xquery_stackprof.rb](xquery_stackprof.rb)
### Usage
```bash
bundle exec ruby xquery_stackprof.rb
bundle exec stackprof-webnav -d tmp/
```

open http://localhost:9292/
