class CreateLsoaTable < ActiveRecord::Migration[6.1]
  def change
    create_table :LSOAs do |t|
      t.string :value
      t.boolean :allowed, default: false
    end
  end
end
