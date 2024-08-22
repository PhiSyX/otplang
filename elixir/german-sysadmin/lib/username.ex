defmodule Username do
  def sanitize(username), do: sanitize(username, [])
  # NOTE: in ascii table the underscore (?_) is placed between ?a and ?z
  defp sanitize([fl | tail], acc_list) when fl >= ?a and fl <= ?z, do: sanitize(tail, [fl | acc_list])
  defp sanitize([], acc_list), do: acc_list |> Enum.reverse()
  defp sanitize([fl | tail], acc_list) do
    case fl do
      ?ä -> sanitize(tail, [?e | [?a | acc_list]])
      ?ö -> sanitize(tail, [?e | [?o | acc_list]])
      ?ü -> sanitize(tail, [?e | [?u | acc_list]])
      ?ß -> sanitize(tail, [?s | [?s | acc_list]])
      ?_ -> sanitize(tail, [fl | acc_list])
      _  -> sanitize(tail, acc_list)
    end
  end
end
