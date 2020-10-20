class Revenue
  attr_reader :revenue, :id

  def initialize(total)
    @revenue = total
    @id = nil
  end
end
