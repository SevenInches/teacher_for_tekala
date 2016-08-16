module Tekala
  class School
    def count_array(array)
      # count_hash = {}
      # array.each do |item|
      #   key = item.to_sym
      #   if count = count_hash[key]
      #     count_hash[key] = count + 1
      #   else
      #     count_hash[key] = 1
      #   end
      # end
      # json = []
      # count_hash.each do |value|
      #   subpart = Subpart.first(:name => value[0])
      #   json << {'name': value[0], 'count': value[1], 'weight': subpart.weight}
      # end
      # {'data':json}.to_json
      count_hash = {}
      array.each do |item|
        key = item.to_sym
        if count = count_hash[key]
          count_hash[key] = count + 1
        else
          count_hash[key] = 1
        end
      end
      json = []
      count_hash.each do |value|
        subpart = Subpart.first(:name => value[0])
        json << {'id': subpart.id, 'name': value[0], 'count': value[1], 'weight': subpart.weight}
      end
      {'data':json}.to_json
    end

  end
end
