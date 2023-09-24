module MoodleRb
  class Groups
    include HTTParty
    include Utility

    attr_reader :token, :query_options
    ROOT_CATEGORY = 0

    def initialize(token, url, query_options)
      @token = token
      @query_options = query_options
      self.class.base_uri url
    end

    def index
      response = self.class.get(
        '/webservice/rest/server.php',
        {
          :query => query_hash('core_group_get_groups', token)
        }.merge(query_options)
      )
      check_for_errors(response)
      response.parsed_response
    end

    def add_group_members(params)
      response = self.class.get(
        '/webservice/rest/server.php',
        {
          :query => query_hash('core_group_get_groups', token),
          :body => {
            :members => {
              '0' => {
                :userid => params[:user_id],
                :groupid => params[:group_id]
              }
            }
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
    #     the parent category id inside which the new category will be created
    #     - set to nil for a root category
    # idnumber
    #     the new category external reference. must be unique
    # description
    #     the new category description
  end
end
