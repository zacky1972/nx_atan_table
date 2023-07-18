defmodule NxAtanTable do
  @moduledoc File.read!("README.md")
             |> String.split("<!-- MODULEDOC -->")
             |> Enum.fetch!(1)

  use GenServer

  @impl true
  def init(initial_state) do
    {:ok, initial_state}
  end

  def start_link(initial_state \\ %{}) do
    GenServer.start_link(__MODULE__, initial_state, name: __MODULE__)
  end

  @impl true
  def handle_call({:atan_of_reciprocal, n, b}, _from, state) do
    cache_atan_of_reciprocal({n, b}, state, Map.get(state, {n, b}))
  end

  def atan_of_reciprocal(n, b), do: GenServer.call(__MODULE__, {:atan_of_reciprocal, n, b})

  defp cache_atan_of_reciprocal({n, b}, state, nil) do
    r = atan_of_reciprocal_s(n, state, b)
    {:reply, r, Map.put(state, {n, b}, r)}
  end

  defp cache_atan_of_reciprocal(_, state, r) do
    {:reply, r, state}
  end

  @doc """
  Returns a table of signed integer values
  $2^{b - 2} \\arctan(2^{-i})$ where $0 \\leq i \\leq n - 1$,
  which is `b` bits.
  """
  def table(n, b) do
    Stream.unfold(n, fn
      0 -> nil
      n -> {n - 1, n - 1}
    end)
    |> Stream.map(fn n -> Bitwise.bsl(1, n) end)
    |> Stream.map(& atan_of_reciprocal(&1, b))
    |> Enum.reverse()
    |> Nx.tensor(type: {:s, b})
  end

  defp atan_of_reciprocal_s(0, state, b) do
    {:reply, r1, _state} = cache_atan_of_reciprocal({1, b}, state, Map.get(state, {1, b}))
    Bitwise.bsl(r1, 1)
  end

  defp atan_of_reciprocal_s(1, state, b) do
    {:reply, r1, state} = cache_atan_of_reciprocal({49, b}, state, Map.get(state, {49, b}))
    {:reply, r2, state} = cache_atan_of_reciprocal({57, b}, state, Map.get(state, {57, b}))
    {:reply, r3, state} = cache_atan_of_reciprocal({239, b}, state, Map.get(state, {239, b}))
    {:reply, r4, _state} = cache_atan_of_reciprocal({110443, b}, state, Map.get(state, {110443, b}))
    (12 * r1 + 32 * r2 - 5 * r3 + 12 * r4)
  end

  defp atan_of_reciprocal_s(2, state, b) do
    {:reply, r1, state} = cache_atan_of_reciprocal({3, b}, state, Map.get(state, {3, b}))
    {:reply, r2, _state} = cache_atan_of_reciprocal({7, b}, state, Map.get(state, {7, b}))
    (r1 + r2)
  end

  defp atan_of_reciprocal_s(3, state, b) do
    {:reply, r1, state} = cache_atan_of_reciprocal({5, b}, state, Map.get(state, {5, b}))
    {:reply, r2, _state} = cache_atan_of_reciprocal({8, b}, state, Map.get(state, {8, b}))
    (r1 + r2)
  end

  defp atan_of_reciprocal_s(7, state, b) do
    {:reply, r1, state} = cache_atan_of_reciprocal({8, b}, state, Map.get(state, {8, b}))
    {:reply, r2, _state} = cache_atan_of_reciprocal({57, b}, state, Map.get(state, {57, b}))
    (r1 + r2)
  end

  defp atan_of_reciprocal_s(57, state, b) do
    {:reply, r1, state} = cache_atan_of_reciprocal({32, b}, state, Map.get(state, {32, b}))
    {:reply, r2, _state} = cache_atan_of_reciprocal({73, b}, state, Map.get(state, {73, b}))
    (r1 - r2)
  end

  defp atan_of_reciprocal_s(n, _state, bit) when n > 0 and n < Bitwise.bsl(1, bit - 1) do
    n2 = n * n

    Stream.unfold({0, 0, n, Bitwise.bsl(1, bit - 2)}, fn
      {k, a, b, c} ->
        if c > 0 do
          c = div(Bitwise.bsl(1, bit - 2), b * (Bitwise.bsl(k, 1) + 1))
          b = b * n2

          a =
            case Bitwise.band(k, 1) do
              0 -> a + c
              1 -> a - c
            end

          {
            {k + 1, a, b, c},
            {k + 1, a, b, c}
          }
        end
    end)
    |> Enum.reduce(fn
      {_, a, _, _}, _acc -> a
    end)
  end

  defp atan_of_reciprocal_s(n, _state, bit) when n >= Bitwise.bsl(1, bit - 1) do
    0
  end
end
