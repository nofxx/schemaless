class <%= migration_class_name %> < ActiveRecord::Migration
  def change
<%- fields.each do |act, group| -%>
  <%- group.each do |field| -%>
  <%- if field.reference? -%>
    add_reference :<%= table_name %>, :<%= field.name %><%= field.opts %>
    <%- unless field.polymorphic? -%>
    add_foreign_key :<%= table_name %>, :<%= field.name.pluralize %>
    <%- end -%>
  <%- else -%>
    <%= act %>_column :<%= table_name %>, :<%= field.name %>, :<%= field.type %><%= field.opts %>
    <%- if false # field.has_index? -%>
    add_index :<%= table_name %>, :<%= field.index_name %><%= field.opts %>
    <%- end -%>
  <%- end -%>
<%- end -%>
<%- end -%>
  end
<%- if migration_action == 'join' -%>
    create_join_table :<%= join_tables.first %>, :<%= join_tables.second %> do |t|
    <%- fields.each do |field| -%>
      <%= '# ' unless field.has_index? -%>t.index <%= field.index_name %><%= field.opts %>
    <%- end -%>
    end
  end
<%- end -%>
end
