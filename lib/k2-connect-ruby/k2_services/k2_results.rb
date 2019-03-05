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
                :currency

  def components(the_body)
    @id = the_body.dig("id")
    @resource_id = the_body.dig("resourceId")
    @topic = the_body.dig("topic")
    @created_at = the_body.dig("created_at")
    @event = the_body.dig("event")
    @type = the_body.dig("event", "type")
    @resource = the_body.dig("event", "resource")
    @links = the_body.dig("_links")
  end

end