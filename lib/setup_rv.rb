# frozen_string_literal: true

# SetupRv Acceptance Tests
#
# These tests run AFTER the GitHub Action has executed.
# They verify that the action correctly installed Ruby, rv, and ore.
#
# The actual action logic is in action.yml (pure bash).
# Ruby is only available for testing because the action installed it.
module SetupRv
  VERSION = '0.1.0'
end
