module ActiveSupportCacheEntryExtension
  attr_reader :generation_time

  def initialize(value, compressed: false, version: nil, expires_in: nil, expires_at: nil, generation_time: 0.0, **)
    @value      = value
    @version    = version
    @created_at = 0.0
    @expires_in = expires_at&.to_f || expires_in && (expires_in.to_f + Time.now.to_f)
    @compressed = true if compressed
    @generation_time = generation_time
  end

  def should_expire_early?(beta: 1)
    Time.now.to_f - @generation_time * beta * Math.log(Kernel.rand) >= expires_at
  end
end
ActiveSupport::Cache::Entry.prepend(ActiveSupportCacheEntryExtension)
