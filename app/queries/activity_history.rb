class ActivityHistory
  def self.all
    PaperTrail::Version
      .includes(:item)
      .where("item_type = :type AND object_changes::jsonb ? :key", type: Spool.name, key: "remaining_weight_grams")
  end
end
