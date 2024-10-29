defmodule Anagram do
  @doc """
  Returns all candidates that are anagrams of, but not equal to, 'base'.
  """
  @spec match(String.t(), [String.t()]) :: [String.t()]
  def match(base, candidates) do
    with base <- String.downcase(base),
         candidates <-
           Enum.filter(
             candidates,
             &anagram?(base, &1 |> String.downcase())
           ) do
      candidates
    end
  end

  defp anagram?(base, base), do: false

  defp anagram?(base, candidate) do
    String.codepoints(base)
      |> Enum.sort() === candidate
      |> String.codepoints()
      |> Enum.sort()
  end
end
