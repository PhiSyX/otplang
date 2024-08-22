defmodule NameBadge do
  @default_department "Owner"

  def print(id, name, department) do
    mid = if id do "[" <> Integer.to_string(id) <> "] - " else "" end;
    mdep = String.upcase(department || @default_department);
    mid <> name <> " - " <> mdep
  end
end
