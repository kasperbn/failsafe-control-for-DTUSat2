require 'test_helper'

class ObservationTest < ActiveSupport::TestCase
  test "the format of position" do
    assert Observation.new(:position => "55 46 37.7 N 12 17 21.4 E").valid?
    assert !Observation.new(:position => "55 46 37.7 N").valid?
    assert !Observation.new(:position => "55 46 37,7 N 12 17 21,4 E").valid?
    assert !Observation.new(:position => "55.0 46.0 37.7 N 12.0 17.0 21.4 E").valid?
  end
end
