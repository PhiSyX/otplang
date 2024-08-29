defmodule RPNCalculator.Exception do
  defmodule DivisionByZeroError do
    defexception message: "division by zero occurred"
  end

  defmodule StackUnderflowError do
    @default_message "stack underflow occurred"

    defexception message: @default_message

    @impl true
    def exception([]), do: %StackUnderflowError{}

    @impl true
    def exception(ctx_err) do
      %StackUnderflowError{message: @default_message <> ", context: " <> ctx_err}
    end
  end

  def divide([0, _]), do: raise(DivisionByZeroError)
  def divide([divisor, dividend]), do: dividend / divisor
  def divide(_), do: raise(StackUnderflowError, "when dividing")
end
