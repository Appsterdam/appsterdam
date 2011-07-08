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
    unless work_types.blank? and platforms.blank?
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
  
  def member_meta(member)
    meta = []
    meta << member_description(member) unless member.entity.blank?
    meta << 'Available for hire' if member.available_for_hire? 
    "<div class=\"meta\">#{meta.join('<br>')}</div>" unless meta.empty?
  end
end
