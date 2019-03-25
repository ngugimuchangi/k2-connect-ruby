class K2Result
  attr_reader :id,
              :resource_id,
              :topic,
              :created_at,
              :event,
              :type,
              :resource,
              :links,
              :self,
              :amount,
              :currency,
              :first_name,
              :middle_name,
              :last_name

  # TODO, David Nino, alter first_name and co.
  def components(the_body)
    @id = the_body.dig('id')
    @topic = the_body.dig('topic')
    @created_at = the_body.dig('created_at')
    @resource_id = the_body.dig('resourceId')
    # Links
    @links = the_body.dig('_links')
    @self = the_body.dig('_links','self')
    # Event
    @event = the_body.dig('event')
    @type = the_body.dig('event', 'type')
    @resource = the_body.dig('event', 'resource')
  end
end
