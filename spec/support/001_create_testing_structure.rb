class CreateTestingStructure < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, :other, :language
      t.string :status, default: :active
      t.string :limited, limit: 10
      t.boolean :sex
      t.boolean :public
      t.boolean :cool
      t.integer :number
    end
    create_table :user_skills do |t|
      t.references :user
      t.string :kind
    end
    create_table :user_extras do |t|
      t.references :user
      t.string :key, null: false
    end
    create_table :bikes do |t|
      t.string :name, null: false
      t.integer :cylinders
    end
    create_table :places do |t|
      t.string :name, null: false
    end
  end
end
