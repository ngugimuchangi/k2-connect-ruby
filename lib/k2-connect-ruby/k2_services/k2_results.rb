class K2Result
  attr_accessor :id,
                :resourceId,
                :topic,
                :created_at,
                :event,
                :type,
                :resource,
                :_links,
                :amount,
                :currency,
                :truth_value

  # Initialize with a truth Value
  def initialize(truth_value)
    raise K2NilTruthValue if truth_value.nil?
    if !!truth_value == truth_value
      @truth_value = truth_value
    else
      raise K2InvalidTruthValue
    end
  rescue K2InvalidTruthValue => k3
    puts(k3.message)
  rescue K2NilTruthValue => k2
    puts(k2.message)
  end

  def components(the_body)
    @id = the_body.dig("id")
    @resource_id = the_body.dig("resourceId")
    @topic = the_body.dig("topic")
    @created_at = the_body.dig("created_at")
    @event = the_body.dig("event")
    @type = the_body.dig("event", "type")
    @resource = the_body.dig("event", "resource")
    @links = the_body.dig("_links")
  rescue StandardError => e
    puts(e.message)
  end

end