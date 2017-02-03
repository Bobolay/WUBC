module HasPhones
  def phones=(val)
    puts "phones: #{val.inspect}"
    if val.is_a?(Array)
      val = val.join("\r\n")
    end

    self['phones'] = val

    true
  end

  def phones(parse = true)
    val = self['phones']
    if parse
      if val.blank?
        return []
      end
      return self['phones'].split("\r\n")
    else
      return self['phones']
    end
  end
end