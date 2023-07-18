defmodule NxAtanTableTest do
  use ExUnit.Case
  doctest NxAtanTable

  test "NxAtanTable.table" do
    n = 16
    assert NxAtanTable.table(n, 32) == NxAtanTable.Math.table([bit: 32], n: n)
    assert NxAtanTable.table(n, 64) == NxAtanTable.Math.table([bit: 64], n: n)
  end
end
