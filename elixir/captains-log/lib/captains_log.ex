defmodule CaptainsLog do
  @planetary_classes ["D", "H", "J", "K", "L", "M", "N", "R", "T", "Y"]

  def random_planet_class() do
    @planetary_classes |> Enum.random()
  end

  def random_ship_registry_number() do
    r = Enum.random(1000..9999)
    "NCC-#{r}"
  end

  def random_stardate() do
    41000.0 + :rand.uniform() * 990
  end

  def format_stardate(stardate) do
    :io_lib.format("~.1f", [stardate]) |> Kernel.to_string()
  end
end
