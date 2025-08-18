defmodule Filamentory.Spools do
  @moduledoc """
  The Spools context.
  """

  import Ecto.Query, warn: false
  alias Filamentory.Repo

  alias Filamentory.Spools.Spool

  @doc """
  Returns the list of spools.

  ## Examples

      iex> list_spools()
      [%Spool{}, ...]

  """
  def list_spools(sort_by \\ :name, sort_order \\ :asc)
      when sort_by in [
             :id,
             :name,
             :ovp,
             :refill_only,
             :updated_at,
             :gross_weight_grams,
             :remaining_weight_grams
           ] and sort_order in [:asc, :desc] do
    Spool
    |> order_by([{^sort_order, ^sort_by}, {:asc, :name}, {:asc, :ovp}, {:asc, :id}])
    |> Repo.all()
    |> Repo.preload(filament: :product)
  end

  @doc """
  Gets a single spool.

  Raises `Ecto.NoResultsError` if the Spool does not exist.

  ## Examples

      iex> get_spool!(123)
      %Spool{}

      iex> get_spool!(456)
      ** (Ecto.NoResultsError)

  """
  def get_spool!(id) do
    Repo.get!(Spool, id)
    |> Repo.preload(filament: :product)
  end

  @doc """
  Creates a spool.

  ## Examples

      iex> create_spool(%{field: value})
      {:ok, %Spool{}}

      iex> create_spool(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_spool(attrs \\ %{}) do
    %Spool{}
    |> Spool.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a spool.

  ## Examples

      iex> update_spool(spool, %{field: new_value})
      {:ok, %Spool{}}

      iex> update_spool(spool, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_spool(%Spool{} = spool, attrs) do
    spool
    |> Spool.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a spool.

  ## Examples

      iex> delete_spool(spool)
      {:ok, %Spool{}}

      iex> delete_spool(spool)
      {:error, %Ecto.Changeset{}}

  """
  def delete_spool(%Spool{} = spool) do
    Repo.delete(spool)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking spool changes.

  ## Examples

      iex> change_spool(spool)
      %Ecto.Changeset{data: %Spool{}}

  """
  def change_spool(%Spool{} = spool, attrs \\ %{}) do
    Spool.changeset(spool, attrs)
  end

  @doc """
  Returns some stats about the available spools

  ## Examples

      iex> get_stats()
      %{number_spools: 2, total_grams: 420}

  """
  def get_stats() do
    [number_spools, total_grams] =
      Repo.one(
        from s in "spools",
          select: [
            count(s.id),
            sum(s.remaining_weight_grams)
          ]
      )

    %{number_spools: number_spools, total_grams: total_grams}
  end
end
