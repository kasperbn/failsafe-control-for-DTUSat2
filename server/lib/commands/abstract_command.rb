class AbstractCommand
  def execute
    "Execute #{self.class.to_s} command"
  end
end