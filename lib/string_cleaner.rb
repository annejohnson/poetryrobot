class StringCleaner
  def clean(str)
    str.gsub("\302\240", ' ').
        gsub(/[[:space:]]+/, ' ').
        strip
  end
end
