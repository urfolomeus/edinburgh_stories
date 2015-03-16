class ModerationStateMachine
  VALID_STATES   = %w(unmoderated approved rejected reported)
  REQUIRE_REASON = %w(rejected reported)
  DEFAULT_STATE  = 'unmoderated'

  def self.valid_state?(state)
    VALID_STATES.include?(state)
  end
end

