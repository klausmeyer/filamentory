defmodule FilamentoryWeb.SpoolComponents do
  use Phoenix.Component

  import Number.SI

  def progress_bar(%{spool: spool} = assigns) do
    assigns =
      if is_nil(spool.gross_weight_grams) do
        assigns
        |> assign(weight_grams: spool.filament.product.weight_grams)
        |> assign(remaining_grams: spool.filament.product.weight_grams)
        |> assign(remaining_percent: 100)
      else
        assigns
        |> assign(weight_grams: spool.filament.product.weight_grams)
        |> assign(
          remaining_percent:
            trunc(spool.remaining_weight_grams / spool.filament.product.weight_grams * 100)
        )
      end

    ~H"""
    <div class="mb-1 text-right">
      {number_to_si(@spool.remaining_weight_grams, unit: "g")} / {number_to_si(@weight_grams,
        unit: "g"
      )}
    </div>
    <div class="w-full bg-gray-200 rounded-full h-2.5 mb-4">
      <div class="bg-gray-600 h-2.5 rounded-full" style={"width: #{@remaining_percent}%"}></div>
    </div>
    """
  end
end
