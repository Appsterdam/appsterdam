module MemberHelper
  def member_classes(member)
    classes = %w(member)
    classes << member.entity unless member.entity.blank?
    classes.join(' ')
  end
  
  def member_domain(website)
    return '' if website.blank?
    website.split('://', 2).last
  end
  
  def member_tags(work_types, platforms)
    out = ''
    if !work_types.blank? and !platforms.blank?
      out << '<ul class="tags">'
      for work_type in work_types
        out << "<li>#{Member::WORK_TYPES[work_type]}</li>"
      end
      for platform in platforms
        out << "<li>#{Member::PLATFORMS[platform]}</li>"
      end
      out << '</ul>'
    end
    out
  end
  
  def member_description(member)
    out = "#{member.entity == 'individual' ? 'An' : 'A'} #{member.entity}"
    case member.work_location
    when 'appsterdam'
      out << " in Appsterdam"
    when 'applander'
      out << " close to Appsterdam"
    when 'appbroader'
      out << " interested in Appsterdam"
    end
    out
  end
  
  require 'uri'
  def member_meta(member)
    meta = []
    meta << member_description(member) unless member.entity.blank?
    meta << 'Available for hire' if member.available_for_hire? 
    
    begin
      if member.job_offers_url =~ /^http/
        URI.parse(member.job_offers_url)
        meta << "<a href=\"#{member.job_offers_url}\">We're hiring</a>"
      end
    rescue URI::InvalidURIError
    end
    
    "<div class=\"meta\">#{meta.join('<br>')}</div>" unless meta.empty?
  end
  
  def member_facet_links(selection, facet, options)
    out = ''
    current_label = (value = selection.send(facet)) ? options[value] : options.first[1]
    out << link_to(current_label, '#')
    out << '<ul>'
    options.each do |value, label|
      out << "<li>#{link_to(label, members_path(selection.merge(facet => value)))}</li>"
    end
    out << '</ul>'
  end

  def link_to_next_page
    page = if @members.has_next_page?
      # check if this is the last page to show after wrapping around
      if params[:started_at_page].nil? || @members.current_page != params[:started_at_page].to_i - 1
        @members.current_page + 1
      end
    elsif params[:started_at_page] && params[:started_at_page].to_i < @members.current_page
      1 # wrap around
    end
    if page
      %{<p id="more_listings">#{link_to("Load more member listings", members_path(params.merge(:page => page)))}</p>}.html_safe
    end
  end
end
