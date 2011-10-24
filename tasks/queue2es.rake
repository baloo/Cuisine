desc 'Load data from stomp queue to elasticsearch'
task :queue2es => :environment do

  # Load requirements
  require "rubygems"
  require "stomp"
  require "json"
  require "base64"
  require "time"
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

  # Configure Stomp
  begin
    cnx=Stomp::Client.new(@config['stomp_queue'])
  rescue Errno::ECONNREFUSED
    $stderr.puts "Unable to connect to Stomp queue"
    exit(false)
  end

  cnx.subscribe(config["stomp_queue"], { :ack => :client }) do |data|
    infos=Marshal.load(Base64.decode64(data.body))
    puts infos.inspect if debug
    # Insert into elasticsearch
    Tire.index config["es_index"] do
      store :nodename => infos[:nodename],
            :elapsed_time => infos[:elapsed_time],
            :start_time => infos[:start_time].strftime("%Y/%m/%d %H:%M:%S"),
            :end_time => infos[:end_time].strftime("%Y/%m/%d %H:%M:%S"),
            :updated_resources => infos[:updated_resources],
            :diffs => infos[:diffs]

      refresh
    end

    cnx.acknowledge data
  end

  puts cnx.inspect if debug

  cnx.join
  cnx.close
end

