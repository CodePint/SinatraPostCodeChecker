class CreateLsoaTable < ActiveRecord::Migration[6.1]
  def change
    create_table :LSOAs do |t|
      t.string :value
      t.boolean :allowed, default: false
    end
    add_index :LSOAs, :value, unique: true
  end
end
