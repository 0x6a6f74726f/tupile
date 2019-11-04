defmodule ReportBuilder do
  defmacro __using__(_) do
    quote do
      import ReportBuilder
      alias Tupile.Core.{Repo, Report, Purchase}
    end
  end

  alias Tupile.Core.Report

  def purchase_fields(overrides \\ []) do
    Keyword.merge(
      [
        type: "airline",
        amount: 1000
      ],
      overrides
    )
  end

  def report_fields(overrides \\ []) do
    Keyword.merge([], overrides)
  end

  def build_report(overrides \\ []) do
    overrides
    |> report_fields()
    |> Report.new()
  end

  def build_report_with_two_purchases(overrides \\ []) do
    build_report(overrides)
    |> Report.add_purchase(purchase_fields())
    |> Report.add_purchase(purchase_fields(amount: 150))
  end
end
