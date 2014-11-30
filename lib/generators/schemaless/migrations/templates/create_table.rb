class <%= migration_class_name %> < ActiveRecord::Migration
  def change
    create_table :<%= table_name %> do |t|
<% fields[:add].each do |field| -%>
      t.<%= field.type %> :<%= field.name %><%= field.opts %>
<% end -%>
<% if options[:timestamps] %>
      t.timestamps null: false
<% end -%>
    end
<% indexes[:add].each do |index| -%>
    add_index :<%= table_name %>, :<%= index.name %><%= index.opts %>
<% end -%>
<% fields[:add].select(&:reference?).reject(&:polymorphic?).each do |field| -%>
    add_foreign_key :<%= table_name %>, :<%= field.name.pluralize %>
<% end -%>
  end
end
