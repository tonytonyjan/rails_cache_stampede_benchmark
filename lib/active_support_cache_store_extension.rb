# frozen_string_literal: true

module ActiveSupportCacheStoreExtension
  def x_fetch(key, expires_in:, **)
    entry = CACHE.send(:read_entry, key)

    if !entry || (Time.now.to_f - entry.instance_variable_get(:@delta) * Math.log(rand)) >= entry.expires_at
      start = Time.now.to_f
      value = yield
      delta = Time.now.to_f - start
      entry = ActiveSupport::Cache::Entry.new(value, expires_in:)
      entry.instance_variable_set(:@delta, delta)
      CACHE.send(:write_entry, key, entry, expires_in:)
    end
    entry.value
  end
end
ActiveSupport::Cache::Store.include(ActiveSupportCacheStoreExtension)
