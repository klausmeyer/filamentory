defmodule FilamentoryWeb.SpoolHTML do
  use FilamentoryWeb, :html

  import Number.SI
  import FilamentoryWeb.SpoolComponents

  embed_templates "spool_html/*"

  @doc """
  Renders a spool form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def spool_form(assigns)
end
