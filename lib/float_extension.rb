class Float
  
  def round_to_2dp
    self.round_to(2)
  end
  
  def round_to(exponent)
    tmp = self
    tmp = tmp*(10**exponent)
    tmp = tmp.round
    tmp = tmp / (10.0**exponent)
  end
  
end