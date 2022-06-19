# frozen_string_literal: true

using Mysql2::NestedHashBind::QueryExtension

RSpec.describe Mysql2::NestedHashBind::QueryExtension, :database do
  before do
    db.query(<<~SQL)
      INSERT INTO `users` (`id`, `account_name`)
      VALUES(445, 'sue445')
    SQL

    db.query(<<~SQL)
      INSERT INTO `posts` (`id`, `user_id`, `body`)
      VALUES(1, 445, 'test')
    SQL
  end

  describe "#query" do
    subject { db.query(sql).first }

    context "Exists columns containing dots" do
      let(:sql) do
        <<~SQL
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
      end

      its([:id]) { should eq 1 }
      its([:user_id]) { should eq 445 }
      its([:body]) { should eq "test" }
      its([:users]) { should be_an_instance_of Hash }
      its([:users, :account_name]) { should eq "sue445" }
      its([:users, :authority]) { should eq false }
      its([:users, :del_flg]) { should eq false }
    end

    context "No columns containing dots" do
      let(:sql) do
        <<~SQL
          SELECT
            `posts`.`id`,
            `posts`.`user_id`,
            `posts`.`body`
          FROM `posts`
          INNER JOIN `users` ON `posts`.`user_id` = `users`.`id`
        SQL
      end

      its([:id]) { should eq 1 }
      its([:user_id]) { should eq 445 }
      its([:body]) { should eq "test" }
    end
  end

  describe "#xquery" do
    subject { db.xquery(sql, account_name).first }

    let(:account_name) { "sue445" }

    context "Exists columns containing dots" do
      let(:sql) do
        <<~SQL
          SELECT 
            `posts`.`id`,
            `posts`.`user_id`,
            `posts`.`body`,
            `users`.`account_name` AS `users.account_name`,
            `users`.`authority` AS `users.authority`,
            `users`.`del_flg` AS `users.del_flg`
          FROM `posts`
          INNER JOIN `users` ON `posts`.`user_id` = `users`.`id`
          WHERE `users`.`account_name` = ?
        SQL
      end

      its([:id]) { should eq 1 }
      its([:user_id]) { should eq 445 }
      its([:body]) { should eq "test" }
      its([:users]) { should be_an_instance_of Hash }
      its([:users, :account_name]) { should eq "sue445" }
      its([:users, :authority]) { should eq false }
      its([:users, :del_flg]) { should eq false }
    end

    context "No columns containing dots" do
      let(:sql) do
        <<~SQL
          SELECT 
            `posts`.`id`,
            `posts`.`user_id`,
            `posts`.`body`
          FROM `posts`
          INNER JOIN `users` ON `posts`.`user_id` = `users`.`id`
          WHERE `users`.`account_name` = ?
        SQL
      end

      its([:id]) { should eq 1 }
      its([:user_id]) { should eq 445 }
      its([:body]) { should eq "test" }
    end
  end
end
