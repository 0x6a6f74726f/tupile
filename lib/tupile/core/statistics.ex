defmodule Tupile.Core.Statistics do
  @statistics_to_collect [:min, :max, :average, :median]
  defstruct @statistics_to_collect

  def new(report) do
    data = Enum.map(report.purchases, & &1.amount)
    data = if Enum.empty?(data), do: [0], else: data

    statistics =
      @statistics_to_collect
      |> Enum.reduce(%{}, &calculate(&1, &2, data))

    struct!(__MODULE__, statistics)
  end

  def calculate(:min, acc, data), do: Enum.into(acc, %{min: min(data)})
  def calculate(:max, acc, data), do: Enum.into(acc, %{max: max(data)})
  def calculate(:average, acc, data), do: Enum.into(acc, %{average: average(data)})
  def calculate(:median, acc, data), do: Enum.into(acc, %{median: median(data)})

  defdelegate max(l), to: Enum
  defdelegate min(l), to: Enum
  def median(l), do: Enum.at(l, div(length(l), 2))
  def average(l), do: Enum.sum(l) |> div(length(l))
end
