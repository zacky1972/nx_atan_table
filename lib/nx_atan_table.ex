defmodule NxAtanTable do
  @moduledoc File.read!("README.md")
             |> String.split("<!-- MODULEDOC -->")
             |> Enum.fetch!(1)

  @doc """
  Returns a table of signed integer values
  $2^{b - 2} \\arctan(2^{-i})$ where $0 \\leq i \\leq n - 1$,
  which is `b` bits.
  """
  def table(bit_opts \\ [], opts \\ []) do
    Nx.linspace(0, opts[:n] - 1, opts)
    |> then(&Nx.pow(2, Nx.negate(&1)))
    |> Nx.atan()
    |> Nx.multiply(2 ** (bit_opts[:bit] - 2))
    |> Nx.floor()
    |> Nx.as_type({:s, bit_opts[:bit]})
  end
end
