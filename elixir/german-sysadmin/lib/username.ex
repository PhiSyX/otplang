defmodule Username do
  def sanitize(username) do
    sanitize(username, [])
  end

  # NOTE: in ascii table the underscore is placed between ?a and ?z
  defp sanitize([fl | tail], rest) when fl >= ?a and fl <= ?z do
    sanitize(tail, [fl | rest])
  end

  defp sanitize([fl | tail], rest) do
    case fl do
      ?ä -> sanitize(tail, [?e | [?a | rest]])
      ?ö -> sanitize(tail, [?e | [?o | rest]])
      ?ü -> sanitize(tail, [?e | [?u | rest]])
      ?ß -> sanitize(tail, [?s | [?s | rest]])
      ?_ -> sanitize(tail, [fl | rest])
      _  -> sanitize(tail, rest)
    end
  end

  defp sanitize([], rest) do
    rest
      |> Enum.reverse()
  end
end
