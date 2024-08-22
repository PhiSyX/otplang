# Unit to convert 	volume 	in milliliters (mL)
# mL 	              1 	    1
# US cup 	          1 	    240
# US fluid ounce 	  1 	    30
# US teaspoon 	    1 	    5
# US tablespoon 	  1 	    15

defmodule KitchenCalculator do
  def get_volume(volume_pair) do
    elem(volume_pair, 1)
  end

  def to_milliliter(volume_pair) when elem(volume_pair, 0) == :cup,
                                   do: {:milliliter, elem(volume_pair, 1) * 240}
  def to_milliliter(volume_pair) when elem(volume_pair, 0) == :fluid_ounce,
                                   do: {:milliliter, elem(volume_pair, 1) * 30}
  def to_milliliter(volume_pair) when elem(volume_pair, 0) == :teaspoon,
                                   do: {:milliliter, elem(volume_pair, 1) * 5}
  def to_milliliter(volume_pair) when elem(volume_pair, 0) == :tablespoon,
                                   do: {:milliliter, elem(volume_pair, 1) * 15}
  def to_milliliter(volume_pair) when elem(volume_pair, 0) == :milliliter,
                                   do: {:milliliter, elem(volume_pair, 1)}

  def from_milliliter(volume_pair, unit) when unit == :cup,
                                           do: {unit, elem(volume_pair, 1) / 240}
  def from_milliliter(volume_pair, unit) when unit == :fluid_ounce,
                                           do: {unit, elem(volume_pair, 1) / 30}
  def from_milliliter(volume_pair, unit) when unit == :teaspoon,
                                           do: {unit, elem(volume_pair, 1) / 5}
  def from_milliliter(volume_pair, unit) when unit == :tablespoon,
                                           do: {unit, elem(volume_pair, 1) / 15}
  def from_milliliter(volume_pair, unit) when unit == :milliliter,
                                           do: {unit, elem(volume_pair, 1)}

  def convert(volume_pair, unit) do
    from_milliliter(to_milliliter(volume_pair), unit)
  end
end
