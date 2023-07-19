defmodule NxAtanTableTest do
  use ExUnit.Case
  doctest NxAtanTable

  @epsilon 0.0000001

  describe "NxAtanTable.table" do
    test "32bit" do
      b = 32
      n = 32
      assert NxAtanTable.Math.equals_with_epsilon(NxAtanTable.table(n, b), NxAtanTable.Math.table([bit: b], n: n), @epsilon, b) |> Nx.to_number() == 1
    end

    test "64bit" do
      b = 64
      n = 64
      assert NxAtanTable.Math.equals_with_epsilon(NxAtanTable.table(n, b), NxAtanTable.Math.table([bit: b], n: n), @epsilon, b) |> Nx.to_number() == 1
    end
  end
end
