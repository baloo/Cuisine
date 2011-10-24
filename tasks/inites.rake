desc 'Initialize ElasticSearch with structure'
task [:cuisine, :inites] => :environment do

  # Load requirements
  require "rubygems"
  require "tire"

  # Configuration callback
  @config = {}
  def set(key, value)
    if [:queue2es, :stomp_queue].include?(key)
      @config[key] = value
    end
  end

  # Call configuration
  Padrino.apps_configuration().call

  # Debug ?
  debug = @config[:queue2es][:debug]

  s=Tire.index "chef_reports" do
    delete

    create :mappings => {
      :chef_reports => {
        :properties => {
          :nodename => { :type => "string", :dynamic => "strict" },
          :elapsed_time => { :type => "double", :dynamic => "strict" },
          :start_time => { :type => "date", :format => "yyyy-MM-dd HH:mm:ss", :dynamic => "strict" },
          :end_time => { :type => "date", :format => "yyyy-MM-dd HH:mm:ss", :dynamic => "strict" },
          :updated_resources => { :type => "string", :dynamic => "strict" },
          :diffs => { :type => "string", :dynamic => "strict" },
        }
      }

    }

  end

  puts s.inspect if debug
end

