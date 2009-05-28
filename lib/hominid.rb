require 'xmlrpc/client'

class Hominid
  
  # MailChimp API Documentation: http://www.mailchimp.com/api/1.2/
  MAILCHIMP_API = "http://api.mailchimp.com/1.2/"
  
  def initialize
    load_monkey_brains
    @chimpApi ||= XMLRPC::Client.new2(MAILCHIMP_API)
    return self
  end
  
  def load_monkey_brains
    config = YAML.load(File.open("#{RAILS_ROOT}/config/hominid.yml"))[RAILS_ENV].symbolize_keys
    @chimpUsername  = config[:username].to_s
    @chimpPassword  = config[:password].to_s
    @api_key        = config[:api_key]
    @send_goodbye   = config[:send_goodbye]
    @send_notify    = config[:send_notify]
    @double_opt     = config[:double_opt]
  end
  
  ## Security related methods
  
  def add_api_key
    begin
      @chimpApi ||= XMLRPC::Client.new2(MAILCHIMP_API)
      @chimpApi.call("apikeyAdd", @chimpUsername, @chimpPassword, @api_key)
    rescue
      false
    end
  end
  
  def expire_api_key
    begin
      @chimpApi ||= XMLRPC::Client.new2(MAILCHIMP_API)
      @chimpApi.call("apikeyExpire", @chimpUsername, @chimpPassword, @api_key)
    rescue
      false
    end
  end
  
  def api_keys(include_expired = false)
    begin
      @chimpApi ||= XMLRPC::Client.new2(MAILCHIMP_API)
      @api_keys = @chimpApi.call("apikeys", @chimpUsername, @chimpPassword, @api_key, include_expired)
    rescue
      return nil
    end
  end
  
  ## Campaign related methods
  
  def campaign_content(campaign_id)
    # Get the content of a campaign
    begin
      @content = @chimpApi.call("campaignContent", @api_key, campaign_id)
    rescue
      return nil
    end
  end
  
  def campaigns(filters = {}, start = 0, limit = 50)
    # Get the campaigns for this account
    # API Version 1.2 requires that filters be sent as a hash
    # Available options for the filters hash are:
    #
    #   :campaign_id    = (string)  The ID of the campaign you wish to return. 
    #   :list_id        = (string)  Show only campaigns with this list_id. 
    #   :folder_id      = (integer) Show only campaigns from this folder.
    #   :from_name      = (string)  Show only campaigns with this from_name.
    #   :from_email     = (string)  Show only campaigns with this from_email.
    #   :title          = (string)  Show only campaigns with this title.
    #   :subject        = (string)  Show only campaigns with this subject.
    #   :sedtime_start  = (string)  Show campaigns sent after YYYY-MM-DD HH:mm:ss.
    #   :sendtime_end   = (string)  Show campaigns sent before YYYY-MM-DD HH:mm:ss.
    #   :subject        = (boolean) Filter by exact values, or search within content for filter values.
    begin
      @campaigns = @chimpApi.call("campaigns", @api_key, filters, start, limit)
    rescue
      return nil
    end
  end
  
  def create_campaign(type = 'regular', options = {}, content = {}, segment_options = {}, type_opts = {})
    # Create a new campaign
    begin
      @campaign = @chimpApi.call("campaignCreate", @api_key, type, options, content, segment_options, type_opts)
    rescue
      return nil
    end
  end
  
  def delete_campaign(campaign_id)
    # Delete a campaign
    begin
      @campaign = @chimpApi.call("campaignDelete", @api_key, campaign_id)
    rescue
      false
    end
  end
  
  def replicate_campaign(campaign_id)
    # Replicate a campaign (returns ID of new campaign)
    begin
      @campaign = @chimpApi.call("campaignReplicate", @api_key, campaign_id)
    rescue
      false
    end
  end
  
  def schedule_campaign(campaign_id, time = "#{1.day.from_now}")
    # Schedule a campaign
    ## TODO: Add support for A/B Split scheduling
    begin
      @chimpApi.call("campaignSchedule", @api_key, campaign_id, time)
    rescue
      false
    end
  end
  
  def send_now(campaign_id)
    # Send a campaign
    begin
      @chimpApi.call("campaignSendNow", @api_key, campaign_id)
    rescue
      false
    end
  end
  
  def send_test(campaign_id, emails = {})
    # Send a test of a campaign
    begin
      @chimpApi.call("campaignSendTest", @api_key, campaign_id, emails)
    rescue
      false
    end
  end
  
  def templates
    # Get the templates
    begin
      @templates = @chimpApi.call("campaignTemplates", @api_key)
    rescue
      return nil
    end
  end
  
  def update_campaign(campaign_id, name, value)
    # Update a campaign
    begin
      @chimpApi.call("campaignUpdate", @api_key, campaign_id, name, value)
    rescue
      false
    end
  end
  
  def unschedule_campaign(campaign_id)
    # Unschedule a campaign
    begin
      @chimpApi.call("campaignUnschedule", @api_key, campaign_id)
    rescue
      false
    end
  end
  
  ## Helper methods
  
  def html_to_text(content)
    # Convert HTML content to text
    begin
      @html_to_text = @chimpApi.call("generateText", @api_key, 'html', content)
    rescue
      return nil
    end
  end
  
  def convert_css_to_inline(html, strip_css = false)
    # Convert CSS styles to inline styles and (optionally) remove original styles
    begin
      @html_to_text = @chimpApi.call("inlineCss", @api_key, html, strip_css)
    rescue
      return nil
    end
  end
  
  ## List related methods
  
  def lists
    # Get all of the lists for this mailchimp account
    begin
      @lists = @chimpApi.call("lists", @api_key)
    rescue
      return nil
    end
  end
  
  def create_group(list_id, group)
    # Add an interest group to a list
    begin
      @chimpApi.call("listInterestGroupAdd", @api_key, list_id, group)
    rescue
      false
    end
  end
  
  def create_tag(list_id, tag, name, required = false)
    # Add a merge tag to a list
    begin
      @chimpApi.call("listMergeVarAdd", @api_key, list_id, tag, name, required)
    rescue
      false
    end
  end
  
  def delete_group(list_id, group)
    # Delete an interest group for a list
    begin
      @chimpApi.call("listInterestGroupDel", @api_key, list_id, group)
    rescue
      false
    end
  end
  
  def delete_tag(list_id, tag)
    # Delete a merge tag and all its members
    begin
      @chimpApi.call("listMergeVarDel", @api_key, list_id, tag)
    rescue
      false
    end
  end
  
  def groups(list_id)
    # Get the interest groups for a list
    begin
      @groups = @chimpApi.call("listInterestGroups", @api_key, list_id)
    rescue
      return nil
    end
  end
  
  def member(list_id, email)
    # Get a member of a list
    begin
      @member = @chimpApi.call("listMemberInfo", @api_key, list_id, email)
    rescue
      return nil
    end
  end
  
  def members(list_id, status = "subscribed", since = "2000-01-01 00:00:00", start = 0, limit = 100)
    # Get members of a list based on status
    # Select members based on one of the following statuses:
    #   'subscribed'
    #   'unsubscribed'
    #   'cleaned'
    #   'updated'
    #
    # Select members that have updated their status or profile by providing
    # a "since" date in the format of YYYY-MM-DD HH:MM:SS
    # 
    begin
      @members = @chimpApi.call("listMembers", @api_key, list_id, status, since, start, limit)
    rescue
      return nil
    end
  end
  
  def merge_tags(list_id)
    # Get the merge tags for a list
    begin
      @merge_tags = @chimpApi.call("listMergeVars", @api_key, list_id)
    rescue
      return nil
    end
  end
  
  def subscribe(list_id, email, user_info = {}, email_type = "html", update_existing = true, replace_interests = true)
    # Subscribe a member
    begin
      @chimpApi.call("listSubscribe", @api_key, list_id, email, user_info, email_type, @double_opt, update_existing, replace_interests)
    rescue
      false
    end
  end
  
  def subscribe_many(list_id, subscribers)
    # Subscribe a batch of members
    # subscribers = {:EMAIL => 'example@email.com', :EMAIL_TYPE => 'html'} 
    begin
      @chimpApi.call("listBatchSubscribe", @api_key, list_id, subscribers, @double_opt, true)
    rescue
      false
    end
  end
  
  def unsubscribe(list_id, current_email)
    # Unsubscribe a list member
    begin
      @chimpApi.call("listUnsubscribe", @api_key, list_id, current_email, true, @send_goodbye, @send_notify)
    rescue
      false
    end
  end
  
  def unsubscribe_many(list_id, emails)
    # Unsubscribe an array of email addresses
    # emails = ['first@email.com', 'second@email.com'] 
    begin
      @chimpApi.call("listBatchUnsubscribe", @api_key, list_id, emails, true, @send_goodbye, @send_notify)
    rescue
      false
    end
  end
  
  def update_member(list_id, current_email, user_info = {}, email_type = "")
    # Update a member of this list
    begin
      @chimpApi.call("listUpdateMember", @api_key, list_id, current_email, user_info, email_type, true)
    rescue
      false
    end
  end

end