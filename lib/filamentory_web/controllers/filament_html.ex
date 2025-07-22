defmodule FilamentoryWeb.FilamentHTML do
  use FilamentoryWeb, :html

  embed_templates "filament_html/*"

  @doc """
  Renders a filament form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def filament_form(assigns)
end
