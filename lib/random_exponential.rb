# frozen_string_literal: true

class RandomExponential
  def initialize(rate: 1, random_number_generator: Random.new)
    @rate = rate
    @random_number_generator = random_number_generator
  end

  def rand
    Math.log(1 - @random_number_generator.rand) / -@rate
  end
end
