desc 'Purge stomp queue from all existing elements'
task [:cuisine, :purgequeue] => :environment do

  # Load requirements
  require "rubygems"
  require "stomp"
  require "json"
  require "base64"

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

  cnx.subscribe(stomp_queue, { :ack => :client }) do |data|
    infos=Marshal.load(Base64.decode64(data.body))
    puts infos.inspect 
    cnx.acknowledge data
  end

  puts cnx.inspect

  cnx.join
  cnx.close

end

