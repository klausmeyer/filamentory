defmodule FilamentoryWeb.BrandHTML do
  use FilamentoryWeb, :html

  embed_templates "brand_html/*"

  @doc """
  Renders a brand form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def brand_form(assigns)
end
