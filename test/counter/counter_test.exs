defmodule Exmach.CounterTest do
  use ExUnit.Case
  doctest Exmach.Counter

  test "Counts single item" do
    c = Exmach.Counter.new() |> Exmach.Counter.add(:a)

    assert Exmach.Counter.count(c, :a) == 1
  end

  test "Counts multiple items added one by one" do
    c = Exmach.Counter.new()
    c = Exmach.Counter.add(c, :a)
    c = Exmach.Counter.add(c, :a)

    assert Exmach.Counter.count(c, :a) == 2
  end

  test "Counts items in a list added" do
    c = Exmach.Counter.new()
    items = [:a, :b, :a]
    c = Exmach.Counter.add(c, items)

    assert Exmach.Counter.count(c, :a) == 2
    assert Exmach.Counter.count(c, :b) == 1
  end
end
