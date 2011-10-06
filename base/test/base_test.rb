require 'test_helper'

class BaseTest < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, Base
  end
end
