# frozen_string_literal: true

# The algorithm is based on the Box-Muller transform.
class RandomGaussian
  def initialize(mean: 0, stddev: 1, random_number_generator: Random.new)
    @random_number_generator = random_number_generator
    @mean = mean
    @stddev = stddev
    @valid = false
    @next = nil
  end

  def rand
    if @valid
      @valid = false
      @next
    else
      @valid = true
      sample!
    end
  end

  private

  def sample!
    theta = 2 * Math::PI * @random_number_generator.rand
    radius = Math.sqrt(-2 * Math.log(1 - @random_number_generator.rand))
    scale = @stddev * radius
    @next = @mean + scale * Math.sin(theta)
    @mean + scale * Math.cos(theta)
  end
end
