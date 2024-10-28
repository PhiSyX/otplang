defmodule TakeANumberDeluxe do
  # Client API

  @spec start_link(keyword()) :: {:ok, pid()} | {:error, atom()}
  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, init_arg)
  end

  @spec report_state(pid()) :: TakeANumberDeluxe.State.t()
  def report_state(machine) do
    GenServer.call(machine, :report_state)
  end

  @spec queue_new_number(pid()) :: {:ok, integer()} | {:error, atom()}
  def queue_new_number(machine) do
    GenServer.call(machine, :queue_new_number)
  end

  @spec serve_next_queued_number(pid(), integer() | nil) :: {:ok, integer()} | {:error, atom()}
  def serve_next_queued_number(machine, priority_number \\ nil) do
    GenServer.call(machine, {:serve_next_queued_number, priority_number})
  end

  @spec reset_state(pid()) :: :ok
  def reset_state(machine) do
    GenServer.call(machine, :reset_state)
  end

  # Server callbacks
  use GenServer
  alias TakeANumberDeluxe.State

  @impl GenServer
  def init(args) do
    with {:ok, state} <-
           State.new(
             args[:min_number],
             args[:max_number],
             Keyword.get(args, :auto_shutdown_timeout, :infinity)
           ) do
      {:ok, state, state.auto_shutdown_timeout}
    end
  end

  @impl GenServer
  def handle_call(:report_state, _, state),
    do: {:reply, state, state, state.auto_shutdown_timeout}

  def handle_call(:reset_state, _, state) do
    with {:ok, r_state} <-
           State.new(state.min_number, state.max_number, state.auto_shutdown_timeout) do
      {:reply, :ok, r_state, state.auto_shutdown_timeout}
    end
  end

  def handle_call(:queue_new_number, _, state) do
    with {:ok, number, q_state} <- State.queue_new_number(state) do
      {:reply, {:ok, number}, q_state, state.auto_shutdown_timeout}
    else
      error -> {:reply, error, state, state.auto_shutdown_timeout}
    end
  end

  def handle_call({:serve_next_queued_number, priority_number}, _, state) do
    with {:ok, number, nq_state} <- State.serve_next_queued_number(state, priority_number) do
      {:reply, {:ok, number}, nq_state, state.auto_shutdown_timeout}
    else
      error ->
        {:reply, error, state, state.auto_shutdown_timeout}
    end
  end

  @impl GenServer
  def handle_info(:timeout, state) do
    {:stop, :normal, state}
  end

  def handle_info(_, state) do
    {:noreply, state, state.auto_shutdown_timeout}
  end
end
