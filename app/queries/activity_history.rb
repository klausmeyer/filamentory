class ActivityHistory
  def self.all
    PaperTrail::Version
      .includes(item: { filament: { product: [ :brand, :material, :variant ] } })
      .joins("INNER JOIN spools ON spools.id = versions.item_id")
      .where("versions.item_type = :type", type: Spool.name)
      .where("versions.object_changes::jsonb ? :key", key: "remaining_weight_grams")
  end
end
