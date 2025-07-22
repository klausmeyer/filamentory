defmodule FilamentoryWeb.SpoolComponents do
  use Phoenix.Component

  def progress_bar(%{spool: spool} = assigns) do
    assigns = if is_nil(spool.gross_weight_grams) do
      assigns
      |> assign(weight_grams: spool.filament.product.weight_grams)
      |> assign(remaining_grams: spool.filament.product.weight_grams)
      |> assign(remaining_percent: 100)
    else
      remaining_grams = spool.gross_weight_grams - spool.filament.product.spool_weight_grams

      assigns
      |> assign(weight_grams: spool.filament.product.weight_grams)
      |> assign(remaining_grams: remaining_grams)
      |> assign(remaining_percent: trunc(remaining_grams / spool.filament.product.weight_grams * 100))
    end

    ~H"""
    <div class="mb-1 text-base font-medium dark:text-white text-right">{@remaining_grams}g / {@weight_grams}g</div>
    <div class="w-full bg-gray-200 rounded-full h-2.5 mb-4 dark:bg-gray-700">
      <div class="bg-gray-600 h-2.5 rounded-full dark:bg-gray-300" style={"width: #{@remaining_percent}%"}></div>
    </div>
    """
  end
end
