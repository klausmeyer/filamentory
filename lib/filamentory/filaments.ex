defmodule Filamentory.Filaments do
  @moduledoc """
  The Filaments context.
  """

  import Ecto.Query, warn: false
  alias Filamentory.Repo

  alias Filamentory.Filaments.Filament

  @doc """
  Returns the list of filaments.

  ## Examples

      iex> list_filaments()
      [%Filament{}, ...]

  """
  def list_filaments do
    Filament
    |> order_by(asc: :id)
    |> Repo.all
    |> Repo.preload([:product])
  end

  @doc """
  Gets a single filament.

  Raises `Ecto.NoResultsError` if the Filament does not exist.

  ## Examples

      iex> get_filament!(123)
      %Filament{}

      iex> get_filament!(456)
      ** (Ecto.NoResultsError)

  """
  def get_filament!(id) do
    Repo.get!(Filament, id)
    |> Repo.preload([:product])
  end

  @doc """
  Creates a filament.

  ## Examples

      iex> create_filament(%{field: value})
      {:ok, %Filament{}}

      iex> create_filament(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_filament(attrs \\ %{}) do
    %Filament{}
    |> Filament.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a filament.

  ## Examples

      iex> update_filament(filament, %{field: new_value})
      {:ok, %Filament{}}

      iex> update_filament(filament, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_filament(%Filament{} = filament, attrs) do
    filament
    |> Filament.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a filament.

  ## Examples

      iex> delete_filament(filament)
      {:ok, %Filament{}}

      iex> delete_filament(filament)
      {:error, %Ecto.Changeset{}}

  """
  def delete_filament(%Filament{} = filament) do
    Repo.delete(filament)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking filament changes.

  ## Examples

      iex> change_filament(filament)
      %Ecto.Changeset{data: %Filament{}}

  """
  def change_filament(%Filament{} = filament, attrs \\ %{}) do
    Filament.changeset(filament, attrs)
  end
end
