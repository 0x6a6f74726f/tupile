defmodule Tupile do
  alias Tupile.Repo
  alias Tupile.Boundary.ReportManager

  def build_reports_by_directory(source_dir) do
    source_dir
    |> File.ls!()
    |> Enum.each(&build_report("#{source_dir}/#{&1}"))
  end

  defp build_report(source_path) do
    with :ok <- ReportManager.build_report(source_path, %{}),
         :ok <- add_purchases(source_path),
         :ok <- add_statistics(source_path),
         do: {:ok, source_path},
         else: (error -> error)
  end

  defp add_purchases(source_path) do
    Repo.seed(source_path)
    |> Repo.project(:purchases)
    |> Repo.restrict(&(&1.type == "airline"))
    |> Repo.distinct(& &1.amount)
    |> Enum.each(&ReportManager.add_purchase(source_path, &1))
  end

  defp add_statistics(source_path),
    do: ReportManager.add_statistics(source_path)

  def get_statistics(),
    do:
      ReportManager.build_anonymized_report()
      |> Map.fetch!(:statistics)

  def get_statistics(source_path),
    do:
      ReportManager.lookup_report_by_title(source_path)
      |> Map.get(:statistics)
end
