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

bambu = Repo.insert! %Brand{name: "Bambu Lab"}
elegoo = Repo.insert! %Brand{name: "Elegoo"}

pla = Repo.insert! %Material{name: "PLA"}
petg = Repo.insert! %Material{name: "PETG"}

basic = Repo.insert! %Variant{name: "Basic"}
matte = Repo.insert! %Variant{name: "Matte"}
silk = Repo.insert! %Variant{name: "Silk"}

Repo.insert! %Product{brand: bambu, material: pla, variant: basic, name: "Bambu Lab - PLA Basic"}
Repo.insert! %Product{brand: bambu, material: pla, variant: matte, name: "Bambu Lab - PLA Matte"}

Repo.insert! %Product{brand: elegoo, material: pla, variant: basic, name: "Elegoo - PLA Basic"}
Repo.insert! %Product{brand: elegoo, material: pla, variant: matte, name: "Elegoo - PLA Matte"}

Repo.insert! %Product{brand: elegoo, material: petg, variant: basic, name: "Elegoo - Rapid PETG"}
