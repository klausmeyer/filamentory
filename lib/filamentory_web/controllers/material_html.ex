defmodule FilamentoryWeb.MaterialHTML do
  use FilamentoryWeb, :html

  embed_templates "material_html/*"

  @doc """
  Renders a material form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def material_form(assigns)
end
