defmodule Plot do
  @enforce_keys [:plot_id, :registered_to]
  defstruct [:plot_id, :registered_to]
end

defmodule CommunityGarden do
  def start(opts \\ []) do
    Agent.start(
      fn -> %Plot{plot_id: 1, registered_to: []} end,
      opts
    )
  end

  def list_registrations(pid) do
    Agent.get(pid, & &1.registered_to)
  end

  def register(pid, register_to) do
    Agent.get_and_update(
      pid,
      fn %Plot{
           plot_id: current_plot,
           registered_to: current_registry
         } ->
        plot = %Plot{
          plot_id: current_plot,
          registered_to: register_to
        }

        {
          plot,
          %Plot{
            plot_id: current_plot + 1,
            registered_to: [plot | current_registry]
          }
        }
      end
    )
  end

  def release(pid, plot_id) do
    Agent.update(
      pid,
      fn %Plot{
           plot_id: current_plot,
           registered_to: current_registry
         } ->
        %Plot{
          plot_id: current_plot,
          registered_to: Enum.filter(current_registry, &(&1.plot_id != plot_id))
        }
      end
    )
  end

  def get_registration(pid, plot_id) do
    Agent.get(
      pid,
      fn %Plot{
           registered_to: current_registry
         } ->
        case Enum.find(current_registry, &(&1.plot_id === plot_id)) do
          %Plot{} = plot -> plot
          _ -> {:not_found, "plot is unregistered"}
        end
      end
    )
  end
end
