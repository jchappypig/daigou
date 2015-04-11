class ChangeAmountToStringInOrders < ActiveRecord::Migration
  def change
    reversible do |dir|
      change_table :orders do |t|
        dir.up { t.change :amount, :string }
        dir.down { t.change :amount, 'integer USING (trim(amount)::integer);' }
      end
    end
  end
end
