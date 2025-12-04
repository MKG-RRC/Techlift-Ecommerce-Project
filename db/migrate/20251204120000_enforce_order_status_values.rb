class EnforceOrderStatusValues < ActiveRecord::Migration[7.1]
  def up
    execute <<~SQL.squish
      UPDATE orders
      SET status = 'new'
      WHERE status IS NULL
        OR status = ''
        OR status NOT IN ('new', 'paid', 'shipped')
    SQL

    change_column_default :orders, :status, 'new'
    change_column_null :orders, :status, false
  end

  def down
    change_column_null :orders, :status, true
    change_column_default :orders, :status, nil
  end
end
