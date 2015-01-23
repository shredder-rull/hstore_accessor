require "active_support"
require "active_record"
require "hstore_accessor/version"
require "hstore_accessor/type_helpers"
require "hstore_accessor/time_helper"
require "hstore_accessor/serialization"
require "hstore_accessor/macro"
require "bigdecimal"

module HstoreAccessor
  extend ActiveSupport::Concern
  include Serialization
  include Macro

  def self.included(base)
    base.class_attribute :hstore_attributes
  end

  def as_json(*attrs)
    json = super(*attrs)
    hstore_attributes.each do |hstore_key, hstore_field|
      json.delete(hstore_key.to_s)
      hstore_field.keys.each do |key|
        json[key.to_s] = self.send(key)
      end
    end if hstore_attributes.present?
    json
  end

end

ActiveSupport.on_load(:active_record) do
  ActiveRecord::Base.send(:include, HstoreAccessor)
end
