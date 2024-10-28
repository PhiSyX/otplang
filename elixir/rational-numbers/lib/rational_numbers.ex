defmodule RationalNumbers do
  @type rational :: {integer, integer}

  @doc """
  Add two rational numbers
  """
  @spec add(a :: rational, b :: rational) :: rational
  def add({a, b}, {c, d}) do
    {a * d + c * b, b * d} |> reduce()
  end

  @doc """
  Subtract two rational numbers
  """
  @spec subtract(a :: rational, b :: rational) :: rational
  def subtract({a, b}, {c, d}) do
    {a * d - c * b, b * d} |> reduce()
  end

  @doc """
  Multiply two rational numbers
  """
  @spec multiply(a :: rational, b :: rational) :: rational
  def multiply({a, b}, {c, d}) do
    {a * c, b * d} |> reduce()
  end

  @doc """
  Divide two rational numbers
  """
  @spec divide_by(num :: rational, den :: rational) :: rational
  def divide_by({a, b}, {c, d}) do
    {a * d, c * b} |> reduce()
  end

  @doc """
  Absolute value of a rational number
  """
  @spec abs(a :: rational) :: rational
  def abs({a, b}) do
    {Kernel.abs(a), Kernel.abs(b)} |> reduce()
  end

  @doc """
  Exponentiation of a rational number by an integer
  """
  @spec pow_rational(a :: rational, n :: integer) :: rational
  def pow_rational({a, b}, n) when n < 0 do
    pow_rational({b, a}, -n)
  end

  def pow_rational({a, b}, n) do
    {:math.pow(a, n), :math.pow(b, n)} |> reduce()
  end

  @doc """
  Exponentiation of a real number by a rational number
  """
  @spec pow_real(x :: integer, n :: rational) :: float
  def pow_real(x, n) do
    {a, b} = n |> reduce()
    :math.pow(x, a) |> nth_root(b)
  end

  @doc """
  Reduce a rational number to its lowest terms
  """
  @spec reduce(a :: rational) :: rational
  def reduce({0, _b}), do: {0, 1}

  def reduce({a, b}) do
    with a <- trunc(a), b <- trunc(b), q <- Integer.gcd(a, b), a <- div(a, q), b <- div(b, q) do
      {a, b} |> normalize()
    end
  end

  defp normalize({a, b}) when b < 0, do: normalize({-a, -b})
  defp normalize({a, b}), do: {a, b}

  defp nth_root(number, 1), do: number
  defp nth_root(number, 2), do: :math.sqrt(number)
  defp nth_root(number, root), do: :math.pow(number, 1 / root)
end
