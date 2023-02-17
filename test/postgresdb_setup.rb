####### PostgresDB-specific testing setup/teardown #######

module PostgresDBSetup
  def setup
    @test_connection = PG.connect(dbname: "shopping_list_test")


    [].each do |sql|
      @test_connection.exec(sql)
    end
  end

  def teardown
    @test_connection.exec("DELETE FROM users;")
    @test_connection.close
  end
end