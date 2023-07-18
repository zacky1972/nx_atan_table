defmodule NxAtanTableTest do
  use ExUnit.Case
  doctest NxAtanTable

  describe "NxAtanTable.table" do
    test "32bit" do
      n = 32
      assert NxAtanTable.table(n, 32) == NxAtanTable.Math.table([bit: 32], n: n)
    end

    test "64bit" do
      n = 64
      assert NxAtanTable.table(n, 64) == NxAtanTable.Math.table([bit: 64], n: n)
    end
  end
end
