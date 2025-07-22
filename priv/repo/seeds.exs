# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Filamentory.Repo.insert!(%Filamentory.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Filamentory.Repo
alias Filamentory.Brands.Brand
alias Filamentory.Materials.Material
alias Filamentory.Variants.Variant
alias Filamentory.Products.Product
alias Filamentory.Filaments.Filament

bambu  = Repo.insert! %Brand{name: "Bambu Lab"}
elegoo = Repo.insert! %Brand{name: "Elegoo"}

pla  = Repo.insert! %Material{name: "PLA"}
petg = Repo.insert! %Material{name: "PETG"}

basic = Repo.insert! %Variant{name: "Basic"}
matte = Repo.insert! %Variant{name: "Matte"}
silk  = Repo.insert! %Variant{name: "Silk"}

bambu_pla_basic = Repo.insert! %Product{brand: bambu, material: pla, variant: basic, name: "Bambu Lab - PLA Basic"}
bambu_pla_matte = Repo.insert! %Product{brand: bambu, material: pla, variant: matte, name: "Bambu Lab - PLA Matte"}

elegoo_pla_basic = Repo.insert! %Product{brand: elegoo, material: pla, variant: basic, name: "Elegoo - PLA Basic"}
elegoo_pla_matte = Repo.insert! %Product{brand: elegoo, material: pla, variant: matte, name: "Elegoo - PLA Matte"}

elegoo_petg_basic = Repo.insert! %Product{brand: elegoo, material: petg, variant: basic, name: "Elegoo - Rapid PETG"}

Repo.insert! %Filament{product: bambu_pla_basic, color_name: "Black", color_hex: "#000000"}
Repo.insert! %Filament{product: bambu_pla_basic, color_name: "Gray", color_hex: "#c2c2c2"}

Repo.insert! %Filament{product: bambu_pla_matte, color_name: "Ash Grey", color_hex: "#909396"}
Repo.insert! %Filament{product: bambu_pla_matte, color_name: "Charcoal", color_hex: "#000000"}
Repo.insert! %Filament{product: bambu_pla_matte, color_name: "Dark Red", color_hex: "#b2353b"}
Repo.insert! %Filament{product: bambu_pla_matte, color_name: "Ivory White", color_hex: "#ffffff"}
Repo.insert! %Filament{product: bambu_pla_matte, color_name: "Mandarin Orange", color_hex: "#f88d58"}
Repo.insert! %Filament{product: bambu_pla_matte, color_name: "Marine Blue", color_hex: "#006eb7"}

Repo.insert! %Filament{product: elegoo_pla_basic, color_name: "Black", color_hex: "#000000"}
Repo.insert! %Filament{product: elegoo_pla_basic, color_name: "Dark Blue", color_hex: "#2240af"}
Repo.insert! %Filament{product: elegoo_pla_basic, color_name: "Neon Green", color_hex: "#08e327"}
Repo.insert! %Filament{product: elegoo_pla_basic, color_name: "Translucent", color_hex: "#f3f3f3"}

Repo.insert! %Filament{product: elegoo_petg_basic, color_name: "Red", color_hex: "#ea140e"}
Repo.insert! %Filament{product: elegoo_petg_basic, color_name: "White", color_hex: "#ffffff"}
