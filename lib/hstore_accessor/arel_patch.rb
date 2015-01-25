module HstoreAccessor
  module ArelPath

    def self.included(base)
      base.alias_method_chain :visit_Arel_Attributes_Attribute, :hstore_support
    end

    def visit_Arel_Attributes_Attribute_with_hstore_support o, collector

      join_name = o.relation.table_alias || o.relation.name

      engine = if o.relation.engine == ActiveRecord::Base
                 ActiveRecord::Base.subclasses.index_by(&:table_name)[o.relation.name]
               else
                 o.relation.engine
               end

      if engine and engine.is_hstore_attribute?(o.name)
        hstore_attribute = engine.hstore_parent_attribute(o.name)
        hstore_key = engine.hstore_pg_field(o.name)
        attribute_sql = "#{quote_table_name join_name}.#{quote_column_name hstore_attribute} -> '#{hstore_key}'"
        attribute_sql = "(#{attribute_sql})::#{type}" if type = engine.hstore_pg_type(o.name)
        collector << attribute_sql
      else
        visit_Arel_Attributes_Attribute_without_hstore_support(o, collector)
      end

    end

  end
end