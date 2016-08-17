module Tekala
  class School
    def count_array(array)
      count_hash = {}
      array.each do |item|
        key = item.to_sym
        if count = count_hash[key]
          count_hash[key] = count + 1
        else
          count_hash[key] = 1
        end
      end
      count_hash
    end

  end
end
