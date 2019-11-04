defmodule Tupile.RepoTest do
  use ExUnit.Case, async: true

  alias Tupile.Repo, as: Subject

  doctest Subject

  @user_purchases_file "test/fixtures/user_purchases.json"
  defp assert_result(result) do
    refute is_nil(result)
    result
  end

  test "project distinct amount of airline purchases" do
    expected_result = [%{amount: 9000, type: "airline"}, %{amount: 150, type: "airline"}]

    result =
      Subject.seed(@user_purchases_file)
      |> assert_result()
      |> Subject.project(:purchases)
      |> assert_result()
      |> Subject.restrict(&(&1.type == "airline"))
      |> assert_result()
      |> Subject.distinct(& &1.amount)
      |> assert_result()

    assert result == expected_result
  end
end
