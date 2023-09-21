module MoodleRb
  class Competencies
    include HTTParty
    include Utility

    attr_reader :token, :query_options

    def initialize(token, url, query_options)
      @token = token
      @query_options = query_options
      self.class.base_uri url
    end

    def list_course_competencies(course_id)
      response = self.class.post(
        '/webservice/rest/server.php',
        {
          :query => query_hash('core_competency_list_course_competencies', token),
          :body => {
            :id => course_id
          }
        }.merge(query_options)
      )
      check_for_errors(response)
      response.parsed_response
    end
  end
end
