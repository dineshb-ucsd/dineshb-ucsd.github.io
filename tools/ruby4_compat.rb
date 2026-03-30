# Minimal Ruby 3.2+/4.0 compatibility for older Jekyll/Liquid stacks.
# Liquid 4 still calls taint-related APIs removed from modern Ruby.
class Object
  def tainted?
    false
  end

  def taint
    self
  end

  def untaint
    self
  end
end
