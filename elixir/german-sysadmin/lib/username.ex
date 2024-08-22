defmodule Username do
  ##################
  # First Solution #
  ##################

  # def sanitize(username), do: sanitize(username, [])
  # # NOTE: in ascii table the underscore (?_) is placed between ?a and ?z
  # defp sanitize([fl | tail], acc_list) when fl >= ?a and fl <= ?z, do: sanitize(tail, [fl | acc_list])
  # defp sanitize([], acc_list), do: acc_list |> Enum.reverse()
  # defp sanitize([fl | tail], acc_list) do
  #   case fl do
  #     ?ä -> sanitize(tail, [?e | [?a | acc_list]])
  #     ?ö -> sanitize(tail, [?e | [?o | acc_list]])
  #     ?ü -> sanitize(tail, [?e | [?u | acc_list]])
  #     ?ß -> sanitize(tail, [?s | [?s | acc_list]])
  #     ?_ -> sanitize(tail, [fl | acc_list])
  #     _  -> sanitize(tail, acc_list)
  #   end
  # end

  ###################
  # Second Solution #
  ###################

  def sanitize([]), do: []
  def sanitize([fl | tail]) do
    latin_sub = case fl do
      ?ä -> ~c"ae"
      ?ö -> ~c"oe"
      ?ü -> ~c"ue"
      ?ß -> ~c"ss"
      ?_ -> ~c"_"
      # NOTE: in ascii table the underscore (?_) is placed between ?a and ?z
      cp when cp >= ?a and fl <= ?z -> [cp]
      _ -> ~c""
    end

    latin_sub ++ sanitize(tail)
  end
end
