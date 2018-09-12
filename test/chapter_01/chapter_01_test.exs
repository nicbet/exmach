defmodule Exmach.Chapter01Test do
  use ExUnit.Case

  # -------------- VP of Networking ------------------------------------------------------------------------

  def users() do
    [
      %{"id" => 0, "name" => "Hero"},
      %{"id" => 1, "name" => "Dunn"},
      %{"id" => 2, "name" => "Sue"},
      %{"id" => 3, "name" => "Chi"},
      %{"id" => 4, "name" => "Thor"},
      %{"id" => 5, "name" => "Clive"},
      %{"id" => 6, "name" => "Hicks"},
      %{"id" => 7, "name" => "Devin"},
      %{"id" => 8, "name" => "Kate"},
      %{"id" => 9, "name" => "Klein"}
    ]
  end

  def friendships() do
    [
      {0,1}, {0,2}, {1,2}, {1,3}, {2,3}, {3,4},
      {4,5}, {5,6}, {5,7}, {6,8}, {7,8}, {8,9}
    ]
  end

  def social_network() do
    # Iterate over all friendship pairs
    # we pass in the users() list as intial value for the accumulator
    # then we update user[i] by adding [j] to the "friends" list
    # and update user[j] by adding [i] to the "friends" list
    Enum.reduce(friendships(), users(), fn({i, j}, acc) ->
      acc
      |> List.update_at(i, fn user -> Map.update(user, "friends", [j], &(&1 ++ [j])) end)
      |> List.update_at(j, fn user -> Map.update(user, "friends", [i], &(&1 ++ [i])) end)
    end)
  end

  def number_of_friends(user) do
    Enum.count(user["friends"])
  end

  test "social network built correctly" do
    network = social_network()

    assert Enum.at(network, 0)["friends"] == [1, 2]
    assert Enum.at(network, 1)["friends"] == [0, 2, 3]
    assert Enum.at(network, 2)["friends"] == [0, 1, 3]
    assert Enum.at(network, 3)["friends"] == [1, 2, 4]
    assert Enum.at(network, 4)["friends"] == [3, 5]
    assert Enum.at(network, 5)["friends"] == [4, 6, 7]
    assert Enum.at(network, 6)["friends"] == [5, 8]
    assert Enum.at(network, 7)["friends"] == [5, 8]
    assert Enum.at(network, 8)["friends"] == [6, 7, 9]
    assert Enum.at(network, 9)["friends"] == [8]
  end

  test "total friendships in social network is 24" do
    num_connections =
      social_network()
      |> Enum.map(&number_of_friends/1)
      |> Enum.reduce(0, &+/2)

    assert num_connections == 24
  end

  test "average number of connections is 2.4" do
    friend_counts_for_each_user = for user <- social_network() do
      number_of_friends(user)
    end

    num_connections = Enum.reduce(friend_counts_for_each_user, 0, &+/2)
    num_users = Enum.count(social_network())

    assert num_connections / num_users == 2.4
  end

  test "most connected people" do
    friend_counts_by_id = for {user, index} <- Enum.with_index(social_network()) do
      {index, number_of_friends(user)}
    end
    connected_people = Enum.sort_by(friend_counts_by_id, fn({_index, count}) -> count end, &>=/2)

    assert connected_people == [{1, 3}, {2, 3}, {3, 3}, {5, 3}, {8, 3}, {0, 2}, {4, 2}, {6, 2}, {7, 2}, {9, 1}]
  end

  # -------------- VP of Fraternization ------------------------------------------------------------------------
  def interests() do
    [
      {0, "Hadoop"}, {0, "Big Data"}, {0, "HBase"}, {0, "Java"}, {0, "Spark"}, {0, "Storm"}, {0, "Cassandra"},
      {1, "NoSQL"}, {1, "MongoDB"}, {1, "Cassandra"}, {1, "HBase"}, {1, "Postgres"},
      {2, "Python"}, {2, "Scikit-learn"}, {2, "scipy"}, {2, "numpy"}, {2, "statsmodels"}, {2, "pandas"},
      {3, "R"}, {3, "Python"}, {3, "statistics"}, {3, "regression"}, {3, "probability"},
      {4, "machine learning"}, {4, "regression"}, {4, "decision trees"}, {4, "libsvm"},
      {5, "Python"}, {5, "programming languages"},
      {6, "statistics"}, {6, "probability"}, {6, "mathematics"}, {6, "theory"},
      {7, "neural networks"},
      {8, "neural networks"}, {8, "deep learning"}, {8, "Big Data"}, {8, "artificial intelligence"},
      {9, "Hadoop"}, {9, "Java"}, {9, "MapReduce"}, {9, "Big Data"}
    ]
  end

  def friends_of_friends(social_network, user) do
    Enum.reduce(user["friends"], [], fn(x, acc) ->
      foaf =
        Enum.at(social_network, x)["friends"]
        |> Enum.filter(&(&1 != user["id"]))
      acc ++ foaf
    end)
    |> Enum.filter(fn x -> !Enum.member?(user["friends"], x ) end)
  end

  def users_who_like(interest) do
    interests()
    |> Enum.filter(fn({_id, interest_in}) -> interest_in == interest end)
    |> Enum.map(fn{id, _interest} -> id end)
  end

  def interests_to_user_index() do
    interests()
    |> Enum.reduce(%{}, fn({id, interest}, acc) ->
      Map.update(acc, interest, [id], &([id] ++ &1))
    end)
  end

  def user_to_interests_index() do
    interests()
    |> Enum.reduce(%{}, fn({id, interest}, acc) ->
      Map.update(acc, id, [interest], &([interest] ++ &1))
    end)
  end

  def most_common_interests_with(user) do
    u2i = user_to_interests_index()
    i2u = interests_to_user_index()

    u2i[user]
    |> Enum.flat_map(fn interest -> i2u[interest] end)
    |> Enum.filter(&(&1 != user))
    |> Exmach.Counter.new()
  end

  test "friends of friends" do
    foaf_3 = friends_of_friends(social_network(), Enum.at(social_network(), 3))
    |> Exmach.Counter.new()

    assert foaf_3.elements[0] == 2
    assert foaf_3.elements[5] == 1
  end

  test "users who are interested in Big Data" do
    assert users_who_like("Big Data") == [0,8,9]
  end

  test "users who are interest in Big Data via index" do
    idx = interests_to_user_index()

    assert idx["Big Data"] == [9,8,0]
  end

  test "interests of user 3 via index" do
    idx = user_to_interests_index()

    assert idx[3] == ["probability", "regression", "statistics", "Python", "R"]
  end

  test "common interests with user 3" do
    assert most_common_interests_with(3) == %Exmach.Counter{elements: %{2 => 1, 4 => 1, 5 => 1, 6 => 2}}
  end

  # -------------- VP of Public Relations ---------------------------------------------------------------------
  def salaries_and_tenures() do
    [
      {83000, 8.7},
      {88000, 8.1},
      {48000, 0.7},
      {76000, 6},
      {69000, 6.5},
      {76000, 7.5},
      {60000, 2.5},
      {83000, 10},
      {48000, 1.9},
      {63000, 4.2}
    ]
  end

  def salary_by_tenure_naive() do
    salaries_and_tenures()
    |> Enum.reduce(%{}, fn({salary, tenure}, acc) ->
      Map.update(acc, tenure, [salary], &([salary] ++ &1))
    end)
  end

  def salary_by_tenure_bucketed() do
    salaries_and_tenures()
    |> Enum.reduce(%{}, fn({salary, tenure}, acc) ->
      bucket = cond do
        tenure < 2 -> "less than two"
        tenure < 5 -> "between two and five"
        true -> "more than five"
      end

      Map.update(acc, bucket, [salary], &([salary] ++ &1))
    end)
  end

  def average_salary_by_tenure(hist) do
    hist
    |> Enum.map(fn {key, vals} -> {key, Enum.reduce(vals, 0, &+/2) / Enum.count(vals)} end)
  end

  test "average salary by tenure (naive)" do
    assert salary_by_tenure_naive() |> average_salary_by_tenure()
    ==
    [
      {6, 76000},
      {10, 83000},
      {0.7, 48000},
      {1.9, 48000},
      {2.5, 60000},
      {4.2, 63000},
      {6.5, 69000},
      {7.5, 76000},
      {8.1, 88000},
      {8.7, 83000}
    ]
  end

  test "average salary by tenure (bucketed)" do
    assert salary_by_tenure_bucketed() |> average_salary_by_tenure()
    ==
    [
      {"between two and five", 61500.0},
      {"less than two", 48000.0},
      {"more than five", 79166.66666666667}
    ]
  end

  # -------------- VP of Revenue ---------------------------------------------------------------------

  def experience_account_types() do
    [
      {0.7, "paid"},
      {1.9, "unpaid"},
      {2.5, "paid"},
      {4.2, "unpaid"},
      {6, "unpaid"},
      {6.5, "unpaid"},
      {7.5, "unpaid"},
      {8.1, "unpaid"},
      {8.7, "paid"},
      {10, "paid"}
    ]
  end

  def predict_paid_or_unpaid(yoexp) do
    cond do
      yoexp < 3.0 -> "paid"
      yoexp < 8.5 -> "unpaid"
      true -> "paid"
    end
  end

  def boolean_sum_reducer(true, accumulator) do
    accumulator + 1
  end
  def boolean_sum_reducer(false, accumulator) do
    accumulator
  end

  test "predict paid or unpaid account type" do
    predictions_accurate = for {experience, type} <- experience_account_types() do
      predict_paid_or_unpaid(experience) == type
    end
    acc = (Enum.reduce(predictions_accurate, 0, &boolean_sum_reducer/2) ) / Enum.count(predictions_accurate)
    assert acc == 90/100
  end

  # -------------- VP of Content Strategy ---------------------------------------------------------------------
  def topics_to_blog_about() do
    interests()
    |> Enum.flat_map(fn({_id, interest}) ->
      interest |> String.downcase() |> String.split()
    end)
    |> Exmach.Counter.new()
    |> Exmach.Counter.most_common()
  end

  test "bloggable topics" do
    assert topics_to_blog_about()
    ==
    [
      {"python", 3},
      {"data", 3},
      {"big", 3},
      {"learning", 2},
      {"neural", 2},
      {"statistics", 2},
      {"networks", 2},
      {"hbase", 2},
      {"probability", 2},
      {"hadoop", 2}
    ]
  end
end
