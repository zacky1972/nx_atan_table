defmodule NxAtanTable.Math do
  @moduledoc false

  import Nx.Defn

  defn table(bit_opts \\ [], opts \\ []) do
    Nx.linspace(0, opts[:n] - 1, opts)
    |> then(&Nx.pow(2, Nx.negate(&1)))
    |> Nx.atan()
    |> Nx.multiply(2 ** (bit_opts[:bit] - 2))
    |> Nx.floor()
    |> Nx.as_type({:s, bit_opts[:bit]})
  end

  defn equals_with_epsilon(t1, t2, e, b) do
    Nx.subtract(t1, t2)
    |> Nx.abs()
    |> Nx.reduce_max()
    |> Nx.less(Nx.multiply(e, Nx.pow(2, b - 2)))
  end
end
