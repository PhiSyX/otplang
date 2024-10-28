defmodule DancingDots.Animation do
  @type dot :: DancingDots.Dot.t()
  @type opts :: keyword
  @type error :: any
  @type frame_number :: pos_integer

  @callback init(opts :: opts()) :: {:ok, opts()} | {:error, error()}
  @callback handle_frame(dot :: dot(), frame_number :: frame_number(), opts :: opts()) :: dot()

  defmacro __using__(_) do
    quote do
      @behaviour DancingDots.Animation
      def init(opts) do
        {:ok, opts}
      end

      defoverridable(init: 1)
    end
  end
end

defmodule DancingDots.Flicker do
  alias DancingDots.{Animation, Dot}

  use Animation

  @impl Animation
  def handle_frame(dot, frame, _opts) do
    if rem(frame, 4) == 0 do
      %Dot{dot | opacity: dot.opacity / 2}
    else
      dot
    end
  end
end

defmodule DancingDots.Zoom do
  alias DancingDots.{Animation, Dot}

  use Animation

  @impl Animation
  def init([velocity: velocity] = opts) when is_number(velocity) do
    {:ok, opts}
  end

  @impl Animation
  def init(opts) do
    {:error,
     "The :velocity option is required, and its value must be a number. Got: #{inspect(opts[:velocity])}"}
  end

  @impl Animation
  def handle_frame(dot, frame, opts) do
    %Dot{dot | radius: dot.radius + (frame - 1) * opts[:velocity]}
  end
end
