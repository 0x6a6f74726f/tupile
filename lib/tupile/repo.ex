defmodule Tupile.Repo do
  @moduledoc """
  SQLish Repository
  """

  @doc """
  Reads a JSON file and decodes it via Jason.

  ## Examples
  iex> Tupile.Repo.seed("test/fixtures/empty.json")
  %{}

  iex> Tupile.Repo.seed("test/fixtures/not_a_json.csv")
  {:error, :not_decodable}

  iex> Tupile.Repo.seed("not_existing_file")
  {:error, :not_readable}
  """
  def seed(path), do: path |> File.read() |> handle_seed()
  defp handle_seed({:ok, res}), do: res |> decode_to_json()
  defp handle_seed({:error, _err}), do: {:error, :not_readable}
  defp decode_to_json(res), do: res |> Jason.decode(keys: :atoms!) |> handle_decode_to_json()
  defp handle_decode_to_json({:ok, json}), do: json
  defp handle_decode_to_json({:error, _err}), do: {:error, :not_decodable}

  @doc """
  Projection of a dataset (Map only) by key.

  ## Examples
  iex> Tupile.Repo.project(%{purchases: [1]}, :purchases)
  [1]

  iex> Tupile.Repo.project(%{purchases: [1]}, :airlines)
  {:error, :not_projectable}

  iex> Tupile.Repo.project([airline: %{}], :airlines)
  {:error, :not_projectable}
  """

  # TODO-jht-191026 projection of columns
  def project(data, key, _columns \\ []), do: do_project(data, key)

  defp do_project(data, name) when is_map(data),
    do: Map.fetch(data, name) |> handle_project()

  defp do_project(_, _), do: {:error, :not_projectable}

  defp handle_project({:ok, res}), do: res
  defp handle_project(:error), do: {:error, :not_projectable}

  @doc """
  Restricts a dataset (List only) by a clause function.

  ## Examples
  iex> dataset = [%{type: "a"}, %{type: "b"}]
  iex> Tupile.Repo.restrict(dataset, &(&1.type == "a"))
  [%{type: "a"}]

  iex> Tupile.Repo.restrict([], &(&1.type == "a"))
  []
  """
  def restrict(data, clause_fun), do: do_restrict(data, clause_fun)

  defp do_restrict(data, clause_fun) when not is_list(data) or not is_function(clause_fun),
    do: {:error, :not_restrictable}

  defp do_restrict(data, clause_fun), do: Enum.filter(data, &clause_fun.(&1))

  @doc """
  Distincts a dataset (List only) by a clause function.

  ## Examples
  iex> dataset = [%{a: 100}, %{a: 100}, %{a: 120}]
  iex> Tupile.Repo.distinct(dataset, &(&1))
  [%{a: 100}, %{a: 120}]
  """
  def distinct(data, clause_fun), do: do_distinct(data, clause_fun)

  defp do_distinct(data, clause_fun) when not is_list(data) or not is_function(clause_fun),
    do: {:error, :not_distinctable}

  defp do_distinct(data, clause_fun), do: Enum.uniq_by(data, &clause_fun.(&1))
end
