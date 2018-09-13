defmodule Exmach.Vector do
  defstruct values: []

  def new(list) when is_list(list) do
    %Exmach.Vector{values: list}
  end

  def add(%Exmach.Vector{values: v1}, %Exmach.Vector{values: v2}) do
    added_vals =
      Enum.zip(v1, v2)
      |> Enum.map(fn {e1, e2} -> e1 + e2 end)
    %Exmach.Vector{values: added_vals}
  end

  def subtract(%Exmach.Vector{values: v1}, %Exmach.Vector{values: v2}) do
    subtracted_vals =
      Enum.zip(v1, v2)
      |> Enum.map(fn {e1, e2} -> e1 - e2 end)
    %Exmach.Vector{values: subtracted_vals}
  end

  def sum(vectors), do: Enum.reduce(vectors, &add/2)

  def values(%Exmach.Vector{values: v}), do: v

  def scalar_multiply(%Exmach.Vector{values: v}, c) do
    scaled_vals =
      Enum.map(v, fn e -> e*c end)
      %Exmach.Vector{values: scaled_vals}
  end

  def mean(vectors) do
    n = Enum.count(vectors)
    vectors |> sum |> scalar_multiply(1/n)
  end

  def dot(%Exmach.Vector{values: v1}, %Exmach.Vector{values: v2}) do
    Enum.zip(v1, v2)
    |> Enum.map(fn {e1, e2} -> e1 * e2 end)
    |> Enum.reduce(0, &+/2)
  end

  def sum_of_squares(v = %Exmach.Vector{}), do: dot(v,v)

  def magnitude(v = %Exmach.Vector{}), do: :math.sqrt(sum_of_squares(v))

  def squared_distance(v1 = %Exmach.Vector{}, v2 = %Exmach.Vector{}) do
    subtract(v1, v2)
    |> sum_of_squares()
  end

  def distance(v1 = %Exmach.Vector{}, v2 = %Exmach.Vector{}) do
    :math.sqrt(squared_distance(v1, v2))
  end

end
