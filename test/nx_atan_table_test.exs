defmodule NxAtanTableTest do
  use ExUnit.Case
  doctest NxAtanTable

  test "NxAtanTable.table" do
    n = 16
    assert NxAtanTable.Math.table([bit: 32], [n: n]) == NxAtanTable.Math.table([bit: 32], [n: n])
    assert NxAtanTable.Math.table([bit: 64], [n: n]) == NxAtanTable.Math.table([bit: 64], [n: n])
  end
end
