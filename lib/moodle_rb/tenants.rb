module MoodleRb
  class Tenants
    include HTTParty
    include Utility

    attr_reader :token, :query_options

    def initialize(token, url, query_options)
      @token = token
      @query_options = query_options
      self.class.base_uri url
    end

    def index
      response = self.class.get(
        '/webservice/rest/server.php',
        {
          :query => query_hash('tool_tenant_get_tenants', token)
        }.merge(query_options)
      )
      check_for_errors(response)
      response.parsed_response
    end

    def allocate_users(params)
      response = self.class.get(
        '/webservice/rest/server.php',
        {
          :query => query_hash('tool_tenant_allocate_users', token),
          :body => {
            'allocations[0][userid]' => params[:user_id].to_i,
            'allocations[0][tenantid]' => params[:tenant_id].to_i
          }
        }.merge(query_options)
      )
      check_for_errors(response)
      response.parsed_response
    end

    # required params:
    # name
    # optional params:
    # parent_category
    # the parent category id inside which the new category will be created
    # set to nil for a root category
    # idnumber
    # the new category external reference. must be unique
    # description
    # the new category description
  end
end
