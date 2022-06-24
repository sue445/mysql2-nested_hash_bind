# Benchmark report
## [xquery.rb](xquery.rb)
```bash
$ ruby -v
ruby 3.1.2p20 (2022-04-12 revision 4491bb740a) [x86_64-darwin21]

$ bundle exec ruby benchmark/xquery.rb
Warming up --------------------------------------
Mysql2::Client#xquery
                       705.000  i/100ms
Mysql2::Client#xquery(sql_with_dot) using Mysql2::NestedHashBind::QueryExtension
                       104.000  i/100ms
Mysql2::Client#xquery(sql_without_dot) using Mysql2::NestedHashBind::QueryExtension
                       707.000  i/100ms
Calculating -------------------------------------
Mysql2::Client#xquery
                          6.862k (±11.6%) i/s -     33.840k in   5.085349s
Mysql2::Client#xquery(sql_with_dot) using Mysql2::NestedHashBind::QueryExtension
                        897.359  (±65.2%) i/s -      3.536k in   5.078764s
Mysql2::Client#xquery(sql_without_dot) using Mysql2::NestedHashBind::QueryExtension
                          6.757k (± 6.8%) i/s -     33.936k in   5.057701s
```
