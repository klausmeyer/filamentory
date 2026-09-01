# frozen_string_literal: true

class CreateUserIdentities < ActiveRecord::Migration[8.1]
  def change
    create_table :user_identities do |t|
      t.references :user, null: false, foreign_key: true
      t.string :provider, null: false
      t.string :uid, null: false
      t.string :issuer
      t.string :email
      t.boolean :email_verified, default: false, null: false
      t.string :name
      t.jsonb :raw_info, default: {}, null: false

      t.timestamps null: false
    end

    add_index :user_identities, [ :provider, :uid ], unique: true
    add_index :user_identities, [ :issuer, :uid ], unique: true
  end
end
