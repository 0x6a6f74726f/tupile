defmodule Tupile.Core.ReportTest do
  use ExUnit.Case, async: true
  use ReportBuilder

  alias Tupile.Core.Report, as: Subject
  alias Tupile.Core.Statistics

  doctest Subject

  describe "purchases" do
    setup [:report]

    test "has two purchases", %{report: report} do
      assert report.purchases |> length() == 2
    end

    test "has statistics", %{report: report} do
      expected_result = %Statistics{average: 575, max: 1000, median: 1000, min: 150}
      %Subject{statistics: result} = Subject.add_statistics(report)
      assert expected_result == result
    end
  end

  defp report(context) do
    {:ok, Map.put(context, :report, build_report_with_two_purchases())}
  end
end
