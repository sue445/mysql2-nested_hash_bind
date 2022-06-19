# mysql2-nested_hash_bind
[mysql2](https://github.com/brianmario/mysql2) and [mysql2-cs-bind](https://github.com/tagomoris/mysql2-cs-bind) extension to bind response to nested `Hash`.

This is inspired by https://github.com/jmoiron/sqlx

[![test](https://github.com/sue445/mysql2-nested_hash_bind/actions/workflows/test.yml/badge.svg)](https://github.com/sue445/mysql2-nested_hash_bind/actions/workflows/test.yml)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mysql2-nested_hash_bind'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install mysql2-nested_hash_bind

## Usage
Write `require "mysql2-nested_hash_bind"` and `using Mysql2::NestedHashBind::QueryExtension` in your code

## Example
```ruby
require "mysql2-nested_hash_bind"

using Mysql2::NestedHashBind::QueryExtension

db = Mysql2::Client.new(
  host: ENV.fetch("MYSQL_HOST", "127.0.0.1"),
  port: ENV.fetch("MYSQL_PORT", "3306"),
  username: ENV.fetch("MYSQL_USERNAME"),
  database: ENV.fetch("MYSQL_DATABASE"),
  password: ENV.fetch("MYSQL_PASSWORD", ""),
  charset: "utf8mb4",
  database_timezone: :local,
  cast_booleans: true,
  symbolize_keys: true,
  reconnect: true,
)

rows = db.query(<<~SQL)
  SELECT
    `posts`.`id`,
    `posts`.`user_id`,
    `posts`.`body`,
    `users`.`account_name` AS `users.account_name`,
    `users`.`authority` AS `users.authority`,
    `users`.`del_flg` AS `users.del_flg`
  FROM `posts`
  INNER JOIN `users` ON `posts`.`user_id` = `users`.`id`
SQL

rows.first
#=> {:id=>1, :user_id=>445, :body=>"test", :users=>{:account_name=>"sue445", :authority=>false, :del_flg=>false}}
```

If you do not write `using Mysql2::NestedHashBind::QueryExtension`, it will look like this. (This is the original behavior of `Mysql2::Client#query` and `Mysql2::Client#xquery`)

```ruby
rows.first
#=> {:id=>1, :user_id=>445, :body=>"test", :"users.account_name"=>"sue445", :"users.authority"=>false, :"users.del_flg"=>false}
```

## Note
* If exists columns containing dots, `Mysql2::Client#query` and `Mysql2::Client#xquery` returns `Array<Hash>`
* If no exists columns containing dots, `Mysql2::Client#query` and `Mysql2::Client#xquery` returns `Mysql2::Result` (This is the original behavior of `Mysql2::Client#query` and `Mysql2::Client#xquery`)

## Development
At first, create test database.

e.g.

```sql
CREATE DATABASE mysql2_test;
```

```bash
cp .env.example .env
vi .env
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sue445/mysql2-nested_hash_bind.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
