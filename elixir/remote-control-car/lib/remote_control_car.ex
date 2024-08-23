defmodule RemoteControlCar do
  @enforce_keys [:nickname]
  defstruct battery_percentage: 100,
            distance_driven_in_meters: 0,
            nickname: nil

  def new(nickname \\ "none"), do: %RemoteControlCar{nickname: nickname}

  def display_distance(%RemoteControlCar{distance_driven_in_meters: dist}) do
    "#{dist} meters"
  end

  def display_battery(%RemoteControlCar{battery_percentage: 0}) do
    "Battery empty"
  end

  def display_battery(%RemoteControlCar{battery_percentage: percent}) do
    "Battery at #{percent}%"
  end

  def drive(%RemoteControlCar{battery_percentage: 0} = remote_car) do
    remote_car
  end

  def drive(
        %RemoteControlCar{
          battery_percentage: percent,
          distance_driven_in_meters: dist
        } = car
      ) do
    %{
      car
      | battery_percentage: percent - 1,
        distance_driven_in_meters: dist + 20
    }
  end
end
