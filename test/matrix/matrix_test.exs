defmodule Exmach.MatrixTest do
  use ExUnit.Case
  doctest Exmach.Matrix

  alias Exmach.Matrix

  test "Make a Matrix with 3 rows and 2 columns" do
    mA = Matrix.new(3, 2)
    assert mA == %Matrix{values: [ [0, 0],
                                          [0, 0],
                                          [0, 0]]}
  end

  test "Make a custom 2x3 Matrix" do
    mA = Matrix.new([[1,2,3],
                     [4,5,6]])
    assert mA == %Matrix{values: [[1, 2, 3], [4, 5, 6]]}
  end

  test "Make a 3x2 Matrix of Ones" do
    mA = Matrix.new(3, 2, 1)
    assert mA == %Matrix{values: [ [1, 1],
                                          [1, 1],
                                          [1, 1]]}
  end

  test "Make an Identity Matrix of dimension 4" do
    mA = Matrix.identity(4)
    assert mA == %Matrix{values: [ [1, 0, 0, 0],
                                          [0, 1, 0, 0],
                                          [0, 0, 1, 0],
                                          [0, 0, 0, 1]]}
  end

  test "Return the correct shape of a 4x2 Matrix" do
    mA = Matrix.new(4, 2)
    shape = Matrix.shape(mA)
    assert shape == {4,2}
  end

  test "Get a row of the Matrix" do
    mA = Matrix.new([[1,2,3],
                     [4,5,6]])
    r0 = Matrix.get_row(mA, 0)
    r1 = Matrix.get_row(mA, 1)
    r2 = Matrix.get_row(mA, 2)
    assert r0 == [1,2,3]
    assert r1 == [4,5,6]
    assert r2 == nil
  end

  test "Get a column of the Matrix" do
    mA = Matrix.new([[1,2,3],
                     [4,5,6]])
    c0 = Matrix.get_column(mA, 0)
    c1 = Matrix.get_column(mA, 1)
    c2 = Matrix.get_column(mA, 2)
    c3 = Matrix.get_column(mA, 3)
    assert c0 == [1,4]
    assert c1 == [2,5]
    assert c2 == [3,6]
    assert c3 == nil
  end

  test "get a specific element in row i, column j" do
    mA = Matrix.new([[1,2,3],
                     [4,5,6]])
    val = Matrix.at(mA, 1, 1)
    assert val == 5
  end

  test "set a specifig element in row i, column j" do
    mA = Matrix.new([[1,2,3],
                     [4,5,6]])
    mB = Matrix.put(mA, 1, 1, -2)
    assert mB == %Matrix{values: [[1, 2, 3], [4, -2, 6]]}
  end

end
