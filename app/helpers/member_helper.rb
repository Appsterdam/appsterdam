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
end
