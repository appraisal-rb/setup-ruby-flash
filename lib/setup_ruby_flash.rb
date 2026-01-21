# frozen_string_literal: true

# SetupRubyFlash Acceptance Tests
#
# These tests run AFTER the GitHub Action has executed.
# They verify that the action correctly installed Ruby, rv, and ore.
#
# The actual action logic is in action.yml (pure bash).
# Ruby is only available for testing because the action installed it.
module SetupRubyFlash
  VERSION = '1.4.0'
end
