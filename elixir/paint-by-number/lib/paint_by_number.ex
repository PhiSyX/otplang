defmodule PaintByNumber do
  def palette_bit_size(color_count) when color_count == 0, do: color_count
  def palette_bit_size(color_count) when color_count <= 2, do: 1
  def palette_bit_size(color_count) do
    palette_bit_size((color_count / 2) |> ceil) + 1
  end

  def empty_picture() do
    <<>>
  end

  def test_picture() do
    <<0::2,1::2,2::2,3::2>>
  end

  def prepend_pixel(picture, color_count, pixel_color_index) do
    <<pixel_color_index::size(color_count |> palette_bit_size), picture::bitstring>>
  end

  def get_first_pixel(<<>>, _), do: nil
  def get_first_pixel(picture, color_count) do
    pals = palette_bit_size(color_count)
    <<px::size(pals), _::bitstring>> = picture
    px
  end

  def drop_first_pixel(<<>>, _), do: empty_picture()
  def drop_first_pixel(picture, color_count) do
    pals = palette_bit_size(color_count)
    <<_::size(pals), px::bitstring>> = picture
    px
  end

  def concat_pictures(picture1, <<>>), do: picture1
  def concat_pictures(<<>>, picture2), do: picture2
  def concat_pictures(picture1, picture2) do
    <<picture1::bitstring, picture2::bitstring>>
  end
end
