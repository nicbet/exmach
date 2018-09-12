defmodule Exmach.Counter do
  defstruct elements: %{}

  def new() do
    %Exmach.Counter{}
  end

  def new(list) do
    %Exmach.Counter{}
    |> add(list)
  end

  def add(%Exmach.Counter{elements: elements}, items) when is_list(items) do
    elems =
      items
      |> Enum.reduce(elements, fn(x, acc) -> Map.update(acc, x, 1, &(&1+1)) end)
    %Exmach.Counter{elements: elems}
  end
  def add(%Exmach.Counter{elements: elements}, item) do
    # If elements has a key of item with a value, add 1,
    # otherwise add key and assign initial value of 1
    elems = Map.update(elements, item, 1, &(&1 + 1))
    %Exmach.Counter{elements: elems}
  end

  def count(%Exmach.Counter{elements: elements}, key) do
    case Map.fetch(elements, key) do
      {:ok, value} -> value
      _ -> 0
    end
  end

  def set(%Exmach.Counter{elements: elements}, key, value) do
    elems = Map.put(elements, key, value)
    %Exmach.Counter{elements: elems}
  end

  def remove(%Exmach.Counter{elements: elements}, key) do
    elems = Map.delete(elements, key)
    %Exmach.Counter{elements: elems}
  end

  def most_common(%Exmach.Counter{elements: elements}, n \\ 10) do
    elements
    |> Enum.sort_by(fn {_key, value} -> value end, &>=/2)
    |> Enum.take(n)
  end
end
