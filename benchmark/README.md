# Benchmark report
## Setup
```bash
cp ../.env.example .env
vi .env
```

## [xquery_bench.rb](xquery_bench.rb)
```bash
$ ruby -v
ruby 3.1.2p20 (2022-04-12 revision 4491bb740a) [x86_64-darwin21]

$ bundle exec ruby xquery_bench.rb
============== Benchmark with LIMIT 10, without to_a ==============
Warming up --------------------------------------
Mysql2::Client#xquery
                       490.000  i/100ms
Mysql2::Client#xquery(sql_with_dot) using Mysql2::NestedHashBind::QueryExtension
                       362.000  i/100ms
Mysql2::Client#xquery(sql_without_dot) using Mysql2::NestedHashBind::QueryExtension
                       483.000  i/100ms
Calculating -------------------------------------
Mysql2::Client#xquery
                          5.107k (± 3.1%) i/s -     25.970k in   5.090386s
Mysql2::Client#xquery(sql_with_dot) using Mysql2::NestedHashBind::QueryExtension
                          3.649k (± 3.3%) i/s -     18.462k in   5.064792s
Mysql2::Client#xquery(sql_without_dot) using Mysql2::NestedHashBind::QueryExtension
                          4.804k (± 4.3%) i/s -     24.150k in   5.037482s

Comparison:
Mysql2::Client#xquery:     5106.6 i/s
Mysql2::Client#xquery(sql_without_dot) using Mysql2::NestedHashBind::QueryExtension:     4803.5 i/s - same-ish: difference falls within error
Mysql2::Client#xquery(sql_with_dot) using Mysql2::NestedHashBind::QueryExtension:     3649.1 i/s - 1.40x  (± 0.00) slower

============== Benchmark with LIMIT 10, with to_a ==============
Warming up --------------------------------------
Mysql2::Client#xquery.to_a
                       446.000  i/100ms
Mysql2::Client#xquery(sql_with_dot).to_a using Mysql2::NestedHashBind::QueryExtension
                       359.000  i/100ms
Mysql2::Client#xquery(sql_without_dot).to_a using Mysql2::NestedHashBind::QueryExtension
                       451.000  i/100ms
Calculating -------------------------------------
Mysql2::Client#xquery.to_a
                          4.440k (± 4.7%) i/s -     22.300k in   5.035494s
Mysql2::Client#xquery(sql_with_dot).to_a using Mysql2::NestedHashBind::QueryExtension
                          3.587k (± 7.1%) i/s -     17.950k in   5.034172s
Mysql2::Client#xquery(sql_without_dot).to_a using Mysql2::NestedHashBind::QueryExtension
                          4.330k (± 4.3%) i/s -     21.648k in   5.009239s

Comparison:
Mysql2::Client#xquery.to_a:     4439.7 i/s
Mysql2::Client#xquery(sql_without_dot).to_a using Mysql2::NestedHashBind::QueryExtension:     4330.2 i/s - same-ish: difference falls within error
Mysql2::Client#xquery(sql_with_dot).to_a using Mysql2::NestedHashBind::QueryExtension:     3587.1 i/s - 1.24x  (± 0.00) slower

============== Benchmark with LIMIT 100, without to_a ==============
Warming up --------------------------------------
Mysql2::Client#xquery
                       223.000  i/100ms
Mysql2::Client#xquery(sql_with_dot) using Mysql2::NestedHashBind::QueryExtension
                        94.000  i/100ms
Mysql2::Client#xquery(sql_without_dot) using Mysql2::NestedHashBind::QueryExtension
                       224.000  i/100ms
Calculating -------------------------------------
Mysql2::Client#xquery
                          2.368k (± 4.8%) i/s -     11.819k in   5.002685s
Mysql2::Client#xquery(sql_with_dot) using Mysql2::NestedHashBind::QueryExtension
                        942.892  (± 4.9%) i/s -      4.794k in   5.096560s
Mysql2::Client#xquery(sql_without_dot) using Mysql2::NestedHashBind::QueryExtension
                          2.183k (± 9.7%) i/s -     10.976k in   5.069075s

Comparison:
Mysql2::Client#xquery:     2368.0 i/s
Mysql2::Client#xquery(sql_without_dot) using Mysql2::NestedHashBind::QueryExtension:     2183.3 i/s - same-ish: difference falls within error
Mysql2::Client#xquery(sql_with_dot) using Mysql2::NestedHashBind::QueryExtension:      942.9 i/s - 2.51x  (± 0.00) slower

============== Benchmark with LIMIT 100, with to_a ==============
Warming up --------------------------------------
Mysql2::Client#xquery.to_a
                       157.000  i/100ms
Mysql2::Client#xquery(sql_with_dot).to_a using Mysql2::NestedHashBind::QueryExtension
                        93.000  i/100ms
Mysql2::Client#xquery(sql_without_dot).to_a using Mysql2::NestedHashBind::QueryExtension
                       141.000  i/100ms
Calculating -------------------------------------
Mysql2::Client#xquery.to_a
                          1.478k (± 2.8%) i/s -      7.536k in   5.102039s
Mysql2::Client#xquery(sql_with_dot).to_a using Mysql2::NestedHashBind::QueryExtension
                        947.848  (± 4.3%) i/s -      4.743k in   5.013320s
Mysql2::Client#xquery(sql_without_dot).to_a using Mysql2::NestedHashBind::QueryExtension
                          1.449k (± 3.6%) i/s -      7.332k in   5.066700s

Comparison:
Mysql2::Client#xquery.to_a:     1478.3 i/s
Mysql2::Client#xquery(sql_without_dot).to_a using Mysql2::NestedHashBind::QueryExtension:     1449.1 i/s - same-ish: difference falls within error
Mysql2::Client#xquery(sql_with_dot).to_a using Mysql2::NestedHashBind::QueryExtension:      947.8 i/s - 1.56x  (± 0.00) slower
```

## [xquery_stackprof.rb](xquery_stackprof.rb)
### Usage
```bash
bundle exec ruby xquery_stackprof.rb
bundle exec stackprof-webnav -d tmp/
```

open http://localhost:9292/
