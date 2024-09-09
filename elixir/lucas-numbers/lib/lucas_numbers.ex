defmodule LucasNumbers do
  def generate(1), do: [2]
  def generate(2), do: [2, 1]

  def generate(n) when not is_integer(n) or n < 1 do
    raise ArgumentError, "n must be specified as an integer >= 1"
  end

  def generate(n) do
    Stream.unfold({2, 1}, fn {a, b} -> {a, {b, a + b}} end) |> Enum.take(n)
  end
end
