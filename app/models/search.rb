# Do some monkey patching ... i really like map
class Hash

  def map(&block)
    mapped_hash = {}
    self.each do |key, value|
      mapped_hash[key] = yield value
    end
    mapped_hash
  end

  def map_list(&block)
    mapped_hash = []
    self.each do |key, value|
      mapped_hash.push(yield key, value)
    end
    mapped_hash
  end

end

class Search
  class Unavailable < Exception
  end

  def map2hash(s)
    rslt=s.results.map { |rslt| rslt.to_hash }

    # turn the diff into a hash
    for i in 0..rslt.count-1 do
      rslt_hash = {}
      rslt[i][:diffs].each { |elt| rslt_hash[elt[0]] = elt[1] }
      rslt[i][:diffs]=rslt_hash
    end

    rslt
  end

  def search(criterias, limit = 100)
    str_query = criterias[:string].map_list { |k,v|
      # do we have a wildcard ? change ES syntax
      if v.include?("*") then
        k.to_s+':'+v.to_s
      else
        k.to_s+':"'+v.to_s+'"'
      end
    }.join(" AND ")

    s=Tire.search do
      query { string str_query }
      sort { by :start_time, 'desc' }
      if criterias[:updatedonly] then
        filter :exists, :field => "updated_resources"
      end

      size limit
    end

    map2hash(s)
  end
end
