defmodule DNA do
  @nucleic_acid %{
    ?\s => 0b0000,
    ?A  => 0b0001,
    ?C  => 0b0010,
    ?G  => 0b0100,
    ?T  => 0b1000,
  }

  def encode_nucleotide(code_point) do
    Map.get(@nucleic_acid, code_point)
  end

  def decode_nucleotide(encoded_code) do
    decode_nucleotide(
      Map.keys(@nucleic_acid),
      Map.values(@nucleic_acid),
      encoded_code
    )
  end
  defp decode_nucleotide([k | _], [v | _], encoded_code) when v == encoded_code, do: k
  defp decode_nucleotide([_ | keys], [_ | values], encoded_code) do
    decode_nucleotide(keys, values, encoded_code)
  end

  def encode(dna), do: encode(dna, <<>>)
  defp encode([], bits), do: bits
  defp encode([head | tail], bits) do
    encode(tail, <<bits::bitstring, (<<encode_nucleotide(head)::4>>)>>)
  end

  def decode(dna), do: decode(dna, ~c"")
  defp decode(<<>>, bits), do: bits
  defp decode(<<enc::4, dna::bitstring>>, bits) do
    decode(dna, bits ++ [decode_nucleotide(enc)])
  end
end
