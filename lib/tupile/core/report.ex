defmodule Tupile.Core.Report do
  @moduledoc false
  alias Tupile.Core.{Purchase, Statistics}

  defstruct purchases: [],
            statistics: %{}

  def new(fields) do
    struct!(__MODULE__, fields)
  end

  def add_purchase(report, fields) do
    purchase = Purchase.new(fields)
    purchases = [purchase | report.purchases]
    %{report | purchases: purchases}
  end

  def add_statistics(report) do
    statistics = Statistics.new(report)
    %{report | statistics: statistics}
  end
end
