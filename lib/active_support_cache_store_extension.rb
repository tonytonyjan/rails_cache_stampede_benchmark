# frozen_string_literal: true

module ActiveSupportCacheStoreExtension
  def fetch(name, options = nil, &block)
    if block_given?
      options = merged_options(options)
      key = normalize_key(name, options)

      entry = nil
      unless options[:force]
        instrument(:read, name, options) do |payload|
          cached_entry = read_entry(key, **options, event: payload)
          entry = handle_expired_entry(cached_entry, key, options)
          if entry
            if entry.mismatched?(normalize_version(name, options))
              entry = nil
            else
              begin
                entry.value
              rescue DeserializationError
                entry = nil
              end
            end
          end
          payload[:super_operation] = :fetch if payload
          payload[:hit] = !!entry if payload
        end
      end

      if entry.nil? || options && options[:early_expiration] && entry.should_expire_early?
        save_block_result_to_cache(name, options, &block)
      elsif entry
        get_entry_value(entry, name, options)
      end
    elsif options && options[:force]
      raise ArgumentError, "Missing block: Calling `Cache#fetch` with `force: true` requires a block."
    else
      read(name, options)
    end
  end

  private

  def save_block_result_to_cache(name, options)
    options = options.dup

    result = nil
    generation_time = nil

    instrument(:generate, name, options) do
      generation_time = duration do
        result = yield(name, ActiveSupport::Cache::WriteOptions.new(options))
      end
    end

    options[:generation_time] = generation_time
    write(name, result, options) unless result.nil? && options[:skip_nil]
    result
  end

  def duration
    now = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    yield
    Process.clock_gettime(Process::CLOCK_MONOTONIC) - now
  end
end
ActiveSupport::Cache::Store.prepend(ActiveSupportCacheStoreExtension)
