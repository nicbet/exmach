defmodule ExmachTest do
  use ExUnit.Case
  doctest Exmach

  test "greets the world" do
    assert Exmach.hello() == :world
  end
end
