class Run < Search
  def self.queryblock(&block)
    saved = block
    saved
  end

  def self.load(id)
    criterias = {}
    criterias[:query] = self.queryblock{
        ids [ id ], "document" 
      }

    puts criterias[:query]

    self.search(criterias)
  end
end
