defmodule TupileCLI do
  @options strict: [dir: :string],
           aliases: [d: :dir]

  def main(args) do
    with {:ok, [dir: dir]} <- parse_args(args),
         :ok <- Tupile.build_reports_by_directory(dir) do
      Tupile.get_statistics() |> output()
    else
      error ->
        handle_error(error)
    end
  end

  defp output(%{average: avg, max: max, min: min, median: med}) do
    IO.puts("-------------------------------------------")
    IO.puts("Average: #{avg}")
    IO.puts("Minium:  #{min}")
    IO.puts("Maximum: #{max}")
    IO.puts("Median:  #{med}")
    IO.puts("-------------------------------------------")
  end

  defp handle_error({:error, :invalid_args}) do
    IO.puts("""
    Invalid arguments.
    tupile --dir <directory_to_source_files>
    """)

    exit({:shutdown, 1})
  end

  defp parse_args(args) do
    case OptionParser.parse(args, @options) do
      {[dir: dir], _, _} -> {:ok, [dir: dir]}
      _ -> {:error, :invalid_args}
    end
  end
end
