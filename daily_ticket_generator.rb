require 'net/http'
require 'rexml/document'
require 'open3'

class Daily_Ticket_Generator
  # public access settings
  @username
  @password
  @api_key
  @pj_uri
  @setup_file
  attr_accessor :username
  attr_accessor :password
  attr_accessor :api_key
  attr_accessor :pj_uri
  attr_accessor :setup_file

  # protected access setting
  @limit

  # internal params
  @issue_list # nil | REXML::Document
  @setup_list # nil | REXML::Document

  def initialize
    @limit = 1000
    @issue_list = nil
    @setup_list = nil
  end

  # get active issue list from Redmine project.
  #   get_issue_list -> nil | REXML::Document
  def get_issue_list
    uri            = URI.parse(@pj_uri + '/issues.xml')
    uri.query      = URI.encode_www_form({ :limit => @limit.to_s })
    http           = Net::HTTP.new(uri.host, uri.port)
    if @pj_uri.index("https://") != nil then
      http.use_ssl = true
    end

    request = Net::HTTP::Get.new(uri.path + '?' + uri.query)
    request['Content-Type']      = "text/xml"
    request['X-Redmine-API-Key'] = @api_key
    if @username != nil and @password != nil then
      request.basic_auth(@username, @password)
    end

    begin
      response = http.request(request)
      response.value # raise Net::HTTPResponse if not 20x

      @issue_list = REXML::Document.new(response.body)
    rescue => e
      puts e.class
      puts e.message
      @issue_list = nil
    end

    return @issue_list
  end

  #   get_setup_list -> nil | REXML::Document
  def get_setup_list
    begin
      @setup_list = REXML::Document.new(open(@setup_file))
    rescue => e
      puts e.class
      puts e.message
      @setup_list = nil
    end

    return @setup_list
  end

  # generate_issue -> self
  def generate_issues
    if @setup_list == nil or @issue_list == nil then
      return nil
    end

    g = Marshal.load(Marshal.dump(@setup_list)) # return as generated issue
    @issue_list.elements['issues'].each_element{|i| # i:<issue>
      subject = i.elements['subject'].text

      g.elements['issues'].each_element{|s| # s:<issue>
        target = s.elements['subject'].text
        if subject == target then
           g.elements['issues'].delete s
        end
      }
    }

    # overwrite time settings to suitable time
    g.elements['issues'].each_element{|s| # s:<issue>
      ['start_date', 'due_date'].each{|d|
        setting = s.elements[d].text

        cmd = 'date +%F -d "' + setting + '"'
        out, sts = Open3.capture2e(cmd, :stdin_data=>'')
        if sts == 0 then
          value = out.chomp
        else
          puts "[" + sts.to_s + "] invalid date_cmd: " + date_cmd
          value = ""
        end

        s.elements[d].text = value
      }
    }
    return g
  end

  #   set_issue(REXML::Document issue) -> true | false
  def set_issue(issue)
    uri            = URI.parse(@pj_uri + "/issues.xml")
    http           = Net::HTTP.new(uri.host, uri.port)
    if @pj_uri.index("https://") != nil then
      http.use_ssl = true
    end

    request = Net::HTTP::Post.new(uri.path)
    request["Content-Type"]      = "text/xml"
    request["X-Redmine-API-Key"] = @api_key
    request.body                 = issue.to_s
    if @username != nil and @password != nil then
      request.basic_auth(@username, @password)
    end

    begin
      response = http.request(request)
      response.value # raise Net::HTTPResponse if not 20x

      return true
    rescue => e
      puts e.class
      puts e.message
      return false
    end
  end

  def daily_check
    self.get_setup_list
    self.get_issue_list
    self.generate_issues.elements['issues'].each_element{|issue|
        self.set_issue(issue)
    }
  end
end

