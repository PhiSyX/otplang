defmodule TopSecret do
  def to_ast(str) do
    with {:ok, qt} <- str |> Code.string_to_quoted() do
      qt
    end
  end

  def decode_secret_message(str) do
    to_ast(str)
    |> Macro.prewalker()
    |> Enum.reduce([], fn ast, acc ->
      case ast do
        {op, _, _} when op in [:def, :defp] ->
          {_, acc} = decode_secret_message_part(ast, acc)
          acc

        _ ->
          acc
      end
    end)
    |> Enum.reverse()
    |> Enum.join()
  end

  def decode_secret_message_part(ast, acc) do
    {ast, maybe_decode(ast, acc, nil)}
  end

  defp maybe_decode({op, _, [head | _]}, acc, parent)
    when op in [:def, :defp]
    and is_nil(parent)
  do
    maybe_decode(head, acc, op)
  end
  defp maybe_decode({:when = op, _, [head | _]}, acc, parent)
    when not is_nil(parent)
  do
    maybe_decode(head, acc, op)
  end
  defp maybe_decode({op, _, args}, acc, parent)
    when not is_nil(parent)
  do
    [decoded_function_name(op, args) | acc]
  end
  defp maybe_decode(_, acc, nil), do: acc

  defp decoded_function_name(_, nil), do: ""
  defp decoded_function_name(atom_str, args) do
    atom_str |> Atom.to_string() |> String.slice(0, args |> length())
  end
end
