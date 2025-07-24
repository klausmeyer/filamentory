defmodule Filamentory.Variants do
  @moduledoc """
  The Variants context.
  """

  import Ecto.Query, warn: false
  alias Filamentory.Repo

  alias Filamentory.Variants.Variant

  @doc """
  Returns the list of variants.

  ## Examples

      iex> list_variants()
      [%Variant{}, ...]

  """
  def list_variants do
    Variant
    |> order_by(asc: :name)
    |> Repo.all()
  end

  @doc """
  Gets a single variant.

  Raises `Ecto.NoResultsError` if the Variant does not exist.

  ## Examples

      iex> get_variant!(123)
      %Variant{}

      iex> get_variant!(456)
      ** (Ecto.NoResultsError)

  """
  def get_variant!(id), do: Repo.get!(Variant, id)

  @doc """
  Creates a variant.

  ## Examples

      iex> create_variant(%{field: value})
      {:ok, %Variant{}}

      iex> create_variant(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_variant(attrs \\ %{}) do
    %Variant{}
    |> Variant.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a variant.

  ## Examples

      iex> update_variant(variant, %{field: new_value})
      {:ok, %Variant{}}

      iex> update_variant(variant, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_variant(%Variant{} = variant, attrs) do
    variant
    |> Variant.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a variant.

  ## Examples

      iex> delete_variant(variant)
      {:ok, %Variant{}}

      iex> delete_variant(variant)
      {:error, %Ecto.Changeset{}}

  """
  def delete_variant(%Variant{} = variant) do
    Repo.delete(variant)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking variant changes.

  ## Examples

      iex> change_variant(variant)
      %Ecto.Changeset{data: %Variant{}}

  """
  def change_variant(%Variant{} = variant, attrs \\ %{}) do
    Variant.changeset(variant, attrs)
  end
end
