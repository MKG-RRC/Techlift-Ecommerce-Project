# frozen_string_literal: true
ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Today" do
          para "Orders: #{Order.where('created_at >= ?', Date.current.beginning_of_day).count}"
          para "New users: #{User.where('created_at >= ?', Date.current.beginning_of_day).count}"
          para "Revenue: $#{Order.where('created_at >= ?', Date.current.beginning_of_day).sum(:total).to_f.round(2)}"
        end

        panel "Recent Orders" do
          table_for Order.order(created_at: :desc).limit(5) do
            column("ID") { |o| link_to o.id, admin_order_path(o) }
            column("User") { |o| o.user&.email }
            column("Status", &:status)
            column("Total") { |o| number_to_currency(o.total) }
            column("Placed") { |o| l(o.created_at, format: :short) }
          end
        end
      end

      column do
        panel "Inventory" do
          para "Products: #{Product.count}"
          para "Categories: #{Category.count}"
        end

        panel "Quick Links" do
          para link_to "Orders", admin_orders_path
          para link_to "Products", admin_products_path
          para link_to "Categories", admin_categories_path
          para link_to("Provinces", admin_provinces_path) if respond_to?(:admin_provinces_path)
          para link_to "Users", admin_users_path
        end
      end
    end
  end # content
end
