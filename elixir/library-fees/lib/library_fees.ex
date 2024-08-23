defmodule LibraryFees do
  @day_seconds 24 * 60 * 60
  @noon ~T[12:00:00]

  def datetime_from_string(string) do
    NaiveDateTime.from_iso8601!(string)
  end

  def before_noon?(datetime) do
    Time.compare(
      NaiveDateTime.to_time(datetime),
      @noon
    ) == :lt
  end

  def return_date(checkout_datetime) do
    day = if before_noon?(checkout_datetime), do: 28, else: 29

    NaiveDateTime.add(
      checkout_datetime,
      day * @day_seconds
    )
    |> NaiveDateTime.to_date()
  end

  def days_late(planned_return_date, actual_return_datetime) do
    NaiveDateTime.to_date(actual_return_datetime)
    |> Date.diff(planned_return_date)
    |> max(0)
  end

  def monday?(%{year: year, month: month, day: day}) do
    Date.day_of_week(Date.new!(year, month, day)) == 1
  end

  def calculate_late_fee(checkout, return, rate) do
    expected = datetime_from_string(checkout) |> return_date()
    current = datetime_from_string(return)
    day = days_late(expected, current) * rate
    if monday?(current), do: floor(day * 0.5), else: day
  end
end
