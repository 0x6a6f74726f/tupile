defmodule TupileTest do
  use ExUnit.Case, async: true

  alias Tupile, as: Subject

  doctest Subject

  @user_purchases_dir "test/fixtures/purchases"
  @user_purchases_single "test/fixtures/purchases/1.json"

  setup _ do
    @user_purchases_dir
    |> Subject.build_reports_by_directory()
  end

  test "get_statistics/1" do
    assert %{average: 150, max: 150, median: 150, min: 150} =
             Subject.get_statistics(@user_purchases_single)
  end

  test "build_reports_by_directory/1" do
    assert %{average: 9814, max: 10000, median: 10000, min: 150} = Subject.get_statistics()
  end
end
