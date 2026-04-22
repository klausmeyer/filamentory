class Spool < ApplicationRecord
  belongs_to :filament

  has_paper_trail

  before_validation :sync_remaining_weight_grams

  validates :filament_id, presence: true
  validates :ovp, inclusion: { in: [ true, false ] }
  validates :refill_only, inclusion: { in: [ true, false ] }
  validates :gross_weight_grams, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :remaining_weight_grams, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  private

  def sync_remaining_weight_grams
    return if filament_id.blank?

    loaded_filament = association(:filament).loaded? ? filament : nil

    filament_record =
      if loaded_filament.present? && loaded_filament.id == filament_id
        loaded_filament
      else
        Filament.includes(:product).find_by(id: filament_id)
      end

    return if filament_record.nil? || filament_record.product.nil?

    if gross_weight_grams.present?
      self.remaining_weight_grams = [ gross_weight_grams - filament_record.product.spool_weight_grams, 0 ].max
    else
      self.remaining_weight_grams = filament_record.product.weight_grams
    end
  end

  public

  def name
    loaded_filament = association(:filament).loaded? ? filament : nil

    filament_name =
      if loaded_filament.present? && loaded_filament.id == filament_id
        loaded_filament.name
      else
        Filament.where(id: filament_id).pick(:name)
      end

    filament_name.to_s
  end

  def to_s
    name
  end
end
