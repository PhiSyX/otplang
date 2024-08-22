defmodule TakeANumber do
  def start() do
    spawn(&process/0)
  end

  defp process(n \\ 0) do
    receive do
      {:report_state, sender_pid} -> send(sender_pid, n) |> process()
      {:take_a_number, sender_pid} -> send(sender_pid, n + 1) |> process()
      :stop -> nil
      _ -> process(n)
    end

  end
end
