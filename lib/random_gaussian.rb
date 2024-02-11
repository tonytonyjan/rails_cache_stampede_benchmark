# frozen_string_literal: true

# The algorithm is based on the Box-Muller transform.
class RandomGaussian
  def initialize(mean: 0, stddev: 1, random_number_generator: Random.new)
    @random_number_generator = random_number_generator
    @mean = mean
    @stddev = stddev
    @samples = Thread::Queue.new
  end

  def rand
    loop do
      value = begin
        @samples.pop(true)
      rescue ThreadError
        nil
      end
      return value unless value.nil?

      sample!(@mean, @stddev, @random_number_generator)
    end
  end

  private

  def sample!(mean, stddev, random_number_generator)
    theta = 2 * Math::PI * random_number_generator.rand
    radius = Math.sqrt(-2 * Math.log(1 - random_number_generator.rand))
    scale = stddev * radius
    @samples << mean + scale * Math.cos(theta)
    @samples << mean + scale * Math.sin(theta)
  end
end
