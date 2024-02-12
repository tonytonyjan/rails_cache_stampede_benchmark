# frozen_string_literal: true

# The algorithm is based on the Box-Muller transform.
class RandomGaussian
  def initialize(mean: 0, stddev: 1, random_number_generator: Random.new)
    @random_number_generator = random_number_generator
    @mean = mean
    @stddev = stddev
    @samples = []
  end

  def rand
    sample! if @samples.empty?
    @samples.pop
  end

  private

  def sample!
    theta = 2 * Math::PI * @random_number_generator.rand
    radius = Math.sqrt(-2 * Math.log(1 - @random_number_generator.rand))
    scale = @stddev * radius
    @samples << @mean + scale * Math.cos(theta)
    @samples << @mean + scale * Math.sin(theta)
  end
end
