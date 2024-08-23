defmodule BasketballWebsite do
  def extract_from_path(data, ""), do: data
  def extract_from_path(data, path) do
    [head | tail] = split_by_dot(path)
    extract_from_path(data[head], Enum.join(tail, "."))
  end

  def get_in_path(data, path) do
    Kernel.get_in(data, split_by_dot(path))
  end

  defp split_by_dot(path) do
    String.split(path, ".", trim: true)
  end
end
