defmodule NxAtanTable do
  @moduledoc File.read!("README.md")
             |> String.split("<!-- MODULEDOC -->")
             |> Enum.fetch!(1)

  @doc """
  Returns a table of signed integer values
  $2^{b - 2} \\arctan(2^{-i})$ where $0 \\leq i \\leq n - 1$,
  which is `b` bits.
  """
  def table(_n, _b) do
  end
end
