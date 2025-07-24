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
  def list_spools do
    Spool
    |> order_by([{:asc, :name}, {:asc, :ovp}])
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
    |> Repo.preload([:filament])
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
end
