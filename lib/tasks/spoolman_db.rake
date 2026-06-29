namespace :spoolman_db do
  desc "Import available filaments from a SpoolmanDB source JSON URL"
  task :import_filaments, [ :url ] => :environment do |_task, args|
    url = args[:url].presence || ENV["URL"].presence

    unless url
      abort "Usage: bin/rails 'spoolman_db:import_filaments[https://github.com/Donkie/SpoolmanDB/blob/main/filaments/bambulab.json]'"
    end

    result = SpoolmanDb::ImportFilaments.new(url: url).call

    puts "Brands created: #{result.brands_created}"
    puts "Materials created: #{result.materials_created}"
    puts "Variants created: #{result.variants_created}"
    puts "Products created: #{result.products_created}"
    puts "Products updated: #{result.products_updated}"
    puts "Filaments created: #{result.filaments_created}"
    puts "Filaments updated: #{result.filaments_updated}"
  end
end
