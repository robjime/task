class ApiConstraints
#http://railscasts.com/episodes/350-rest-api-versioning  
  def initialize(options)
    @version = options[:version]
    @default = options[:default]
  end

  def matches?(req)
    @default || req.headers['Accept'].include?("application/v#{@version}")
  end
end