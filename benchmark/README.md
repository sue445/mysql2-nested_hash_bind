# Benchmark report
## [xquery.rb](xquery.rb)
```bash
$ ruby -v
ruby 3.1.2p20 (2022-04-12 revision 4491bb740a) [x86_64-darwin21]

$ bundle exec ruby benchmark/xquery.rb
Warming up --------------------------------------
Mysql2::Client#xquery
                       267.000  i/100ms
Mysql2::Client#xquery with Mysql2::NestedHashBind::QueryExtension
                        78.000  i/100ms
Calculating -------------------------------------
Mysql2::Client#xquery
                          2.612k (±19.7%) i/s -     12.549k in   5.062673s
Mysql2::Client#xquery with Mysql2::NestedHashBind::QueryExtension
                        763.186  (± 7.1%) i/s -      3.822k in   5.032656s
```
