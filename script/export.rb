data = Spool.all.each.map do |spool|
  {
    id: spool.id,
    brand: spool.filament.product.brand.name,
    material: spool.filament.product.material.name,
    variant: spool.filament.product.variant.name,
    color_hex: spool.filament.color_hex,
    color_name: spool.filament.color_name,
    gross_weight_grams: spool.gross_weight_grams,
    remaining_weight_grams: spool.remaining_weight_grams,
    spool_weight_grams: spool.filament.product.spool_weight_grams,
    weight_grams: spool.filament.product.weight_grams,
    ovp: spool.ovp,
    refill_only: spool.refill_only
  }
end

puts JSON.pretty_generate(data)
