defmodule Exmach.VectorTest do
  use ExUnit.Case
  doctest Exmach.Vector

  test "creates vector" do
    v1 = Exmach.Vector.new([1,2])
    assert v1 == %Exmach.Vector{values: [1, 2]}
  end

  test "adds two vectors" do
    v1 = Exmach.Vector.new([1,2])
    v2 = Exmach.Vector.new([2,1])
    v3 = Exmach.Vector.add(v1, v2)
    assert v3 == %Exmach.Vector{values: [3, 3]}
  end

  test "vector sum only positive vectors" do
    v1 = Exmach.Vector.new([1,2])
    v2 = Exmach.Vector.new([2,1])
    v3 = Exmach.Vector.new([1,1])
    assert Exmach.Vector.sum([v1, v2, v3]) == %Exmach.Vector{values: [4, 4]}
  end

  test "vector sum positive and negative vectors" do
    v1 = Exmach.Vector.new([1,2])
    v2 = Exmach.Vector.new([2,1])
    v3 = Exmach.Vector.new([-1,-1])
    assert Exmach.Vector.sum([v1, v2, v3]) == %Exmach.Vector{values: [2, 2]}
  end

  test "Subtract two vectors" do
    v1 = Exmach.Vector.new([2,2])
    v2 = Exmach.Vector.new([1,1])
    assert Exmach.Vector.subtract(v1, v2) == %Exmach.Vector{values: [1, 1]}
  end

  test "scaling a vector" do
    v1 = Exmach.Vector.new([1,2])
    assert Exmach.Vector.scalar_multiply(v1, 6) == %Exmach.Vector{values: [6, 12]}
  end

  test "vector mean" do
    v1 = Exmach.Vector.new([1,2])
    v2 = Exmach.Vector.new([2,1])
    v3 = Exmach.Vector.new([3,3])
    assert Exmach.Vector.mean([v1, v2, v3]) == %Exmach.Vector{values: [2.0, 2.0]}
  end

  test "dot product" do
    v1 = Exmach.Vector.new([0.5,1])
    v2 = Exmach.Vector.new([2,2])
    assert Exmach.Vector.dot(v1, v2) == 3.0
  end

  test "Get vector values as list" do
    v1 = Exmach.Vector.new([1,2])
    assert Exmach.Vector.values(v1) == [1, 2]
  end

  test "Sum of squares of vector" do
    v1 = Exmach.Vector.new([3,2])
    assert Exmach.Vector.sum_of_squares(v1) == ((3*3) + (2*2))
  end

  test "Magnitude of vector" do
    v1 = Exmach.Vector.new([4,3])
    assert Exmach.Vector.magnitude(v1) == 5.0
  end

  test "squared distance" do
    v1 = Exmach.Vector.new([2,1])
    v2 = Exmach.Vector.new([3,2])
    assert Exmach.Vector.squared_distance(v1, v2) == 2
  end

  test "distance" do
    v1 = Exmach.Vector.new([5,1])
    v2 = Exmach.Vector.new([5,5])
    assert Exmach.Vector.distance(v1, v2) == 4.0
  end

end
