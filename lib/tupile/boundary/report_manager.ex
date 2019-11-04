defmodule Tupile.Boundary.ReportManager do
  alias Tupile.Core.Report

  use GenServer

  def init(reports) when is_map(reports) do
    {:ok, reports}
  end

  def init(_report), do: {:error, "report must be a map"}

  def start_link(options \\ []) do
    GenServer.start_link(__MODULE__, %{}, options)
  end

  def handle_call({:build_report, source_path, report_fields}, _from, reports) do
    report = Report.new(report_fields)
    reports = Map.put(reports, source_path, report)
    {:reply, :ok, reports}
  end

  def handle_call({:add_purchase, report_source_path, purchase_fields}, _from, reports) do
    reports = Map.update!(reports, report_source_path, &Report.add_purchase(&1, purchase_fields))
    {:reply, :ok, reports}
  end

  def handle_call({:add_statistics, report_source_path}, _from, reports) do
    reports = Map.update!(reports, report_source_path, &Report.add_statistics/1)
    {:reply, :ok, reports}
  end

  def handle_call({:lookup_report_by_title, report_source_path}, _from, reports) do
    {:reply, reports[report_source_path], reports}
  end

  def handle_call({:build_anonymized_report}, _from, reports) do
    anonymized_purchases =
      reports
      |> Enum.map(&(&1 |> elem(1) |> Map.fetch!(:purchases)))
      |> List.flatten()
      |> Enum.group_by(& &1.amount)
      # XXX-jht-191101 anonymization step, drop grouped purchases which are less than 5 times
      |> Enum.reject(&(&1 |> elem(1) |> length() <= 5))
      |> Enum.map(&elem(&1, 1))
      |> List.flatten()

    anonymized_report =
      Report.new(%{purchases: anonymized_purchases})
      |> Report.add_statistics()

    {:reply, anonymized_report, reports}
  end

  def build_report(manager \\ __MODULE__, source_path, report_fields) do
    GenServer.call(manager, {:build_report, source_path, report_fields})
  end

  def add_purchase(manager \\ __MODULE__, report_source_path, purchase_fields) do
    GenServer.call(manager, {:add_purchase, report_source_path, purchase_fields})
  end

  def add_statistics(manager \\ __MODULE__, report_source_path) do
    GenServer.call(manager, {:add_statistics, report_source_path})
  end

  def lookup_report_by_title(manager \\ __MODULE__, report_source_path) do
    GenServer.call(manager, {:lookup_report_by_title, report_source_path})
  end

  def build_anonymized_report(manager \\ __MODULE__) do
    GenServer.call(manager, {:build_anonymized_report})
  end
end
