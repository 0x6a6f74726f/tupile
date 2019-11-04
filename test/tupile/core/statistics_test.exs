defmodule Tupile.Core.StatisticsTest do
  use ExUnit.Case, async: true
  use ReportBuilder
  alias Tupile.Core.Statistics, as: Subject

  doctest Subject

  describe "low level arithmetic" do
    setup [:datalist]

    test "max number of a list", %{datalist: datalist} do
      assert Subject.max(datalist) == 25
    end

    test "min number of a list", %{datalist: datalist} do
      assert Subject.min(datalist) == 1
    end

    test "median number of a list", %{datalist: datalist} do
      assert Subject.median(datalist) == 1
    end

    test "average number of a list", %{datalist: datalist} do
      assert Subject.average(datalist) == 12
    end
  end

  describe "with report" do
    setup [:report]

    test "final statistics by report", %{report: report} do
      assert %Subject{average: 575, max: 1000, min: 150, median: 1000} = Subject.new(report)
    end
  end

  defp report(context) do
    {:ok, Map.put(context, :report, build_report_with_two_purchases())}
  end

  defp datalist(context) do
    {:ok, Map.put(context, :datalist, [12, 10, 5, 1, 25, 20])}
  end
end
