defmodule Exmach.Matrix do
  defstruct values: []

  def make_matrix(rows, cols, generator) do
    vals = for i <- 1..rows, do: for j <- 1..cols, do: generator.(i,j)
    %Exmach.Matrix{values: vals}
  end

  def new(rows, cols, init_val \\ 0)
  when is_integer(rows) and is_integer(cols) do
    make_matrix(rows, cols, fn (_i, _k) -> init_val end)
  end

  def new(entries)
  when is_list(entries) do
    %Exmach.Matrix{values: entries}
  end

  def identity(dim) when is_integer(dim) do
    make_matrix(dim, dim, fn (i,j) -> if (i==j), do: 1, else: 0 end)
  end

  def shape(%Exmach.Matrix{values: vals}) do
    k = Enum.count(vals)
    l = Enum.count(Enum.at(vals, 0))
    {k,l}
  end

  def get_row(%Exmach.Matrix{values: vals}, k) do
    Enum.at(vals, k)
  end

  def get_column(m = %Exmach.Matrix{values: vals}, col) do
    {_k, l} = shape(m)
    cond do
      col < l -> Enum.map(vals, fn row -> Enum.at(row, col) end)
      true    -> nil
    end
  end

  def at(%Exmach.Matrix{values: vals}, i, j) do
      vals |> Enum.at(i) |> Enum.at(j)
  end

  def put(%Exmach.Matrix{values: vals}, i, j, v) do
    r = vals |> Enum.at(i)
    r_new = List.replace_at(r, j, v)
    vals_new = List.replace_at(vals, i, r_new)
    %Exmach.Matrix{values: vals_new}
  end


end
