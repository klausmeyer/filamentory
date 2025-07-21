defmodule FilamentoryWeb.VariantHTML do
  use FilamentoryWeb, :html

  embed_templates "variant_html/*"

  @doc """
  Renders a variant form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def variant_form(assigns)
end
