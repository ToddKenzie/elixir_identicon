defmodule IdenticonTest do
  use ExUnit.Case
  doctest Identicon

  test "hash_input converts 'elixir' to list of numbers" do
    solution = [116, 181, 101, 134, 90, 25, 44, 200, 105, 60, 83, 13, 72, 235, 56, 58]
    test_solution = Identicon.hash_input("elixir")
    assert test_solution == solution
  end

  test "hash_input converts 'phoenix' to different list of numbers than 'elixir'" do
    solution = [179, 217, 119, 70, 219, 180, 94, 146, 220, 8, 61, 178, 5, 225, 253, 20]
    elixir_solution = Identicon.hash_input("elixir")
    test_solution = Identicon.hash_input("phoenix")
    assert test_solution == solution
    refute test_solution == elixir_solution
  end

  test "mirror_row mirrors the first two values of a list of three to the end" do
    solution = [3, 2, 1, 2, 3]
    test_solution = Identicon.mirror_row([3, 2, 1])
    assert test_solution == solution
  end
  
end

