class Spool < ApplicationRecord
  INVENTORY_TAG_ALPHABET = %w[1 2 3 4 5 6 7 8 9 A B C D E F G H J K M N P Q R S T V W X Y Z].freeze
  INVENTORY_TAG_LENGTH = 5

  belongs_to :filament

  has_paper_trail

  before_validation :set_defaults
  before_validation :sync_remaining_weight_grams

  validates :filament_id, presence: true
  validates :inventory_tag, uniqueness: { case_sensitive: false, allow_nil: true }
  validates :ovp, inclusion: { in: [ true, false ] }
  validates :refill_only, inclusion: { in: [ true, false ] }
  validates :gross_weight_grams, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :remaining_weight_grams, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def self.sorted_by_filament
    eager_load(filament: { product: [ :brand, :material, :variant ] }).order(
      brands:    { name: :asc },
      materials: { name: :asc },
      variants:  { name: :asc },
      filament:  { color_hex: :asc },
      spools:    { remaining_weight_grams: :asc }
    )
  end

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

  def number_of_same_filament
    @number_of_same_filament ||= self.class.where(filament_id: filament_id).count
  end

  private

  def set_defaults
    self.inventory_tag = random_inventory_tag if inventory_tag.blank?
  end

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

  def random_inventory_tag
    loop do
      code = INVENTORY_TAG_ALPHABET.sample(INVENTORY_TAG_LENGTH).join

      next if self.class.any?(inventory_tag: code)

      break code.upcase
    end
  end
end
