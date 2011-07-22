def add_work_type(member, type)
  types = member.work_types || []
  types << type
  member.work_types = types
end

Dir.glob(Rails.root + 'db/seeds/*.json').each do |file|
  list_name = File.basename(file, '.json').split('-').first
  list = JSON.parse(File.read(file))
  users = list['users']
  users.each do |attributes|
    member = Member.find_by_twitter_id(attributes['id'].to_s) ||
               Member.create_with_twitter_user_attributes(attributes)
    case list_name
    when 'companies'
      member.entity = 'company'
    when 'students'
      member.entity = 'student'
    when 'collectives'
      member.entity = 'group'
    when 'available'
      unless member.entity == 'company'
        # NOTE this doesn't need to be true, but just trying to get some dev data right now
        member.entity = 'individual'
        member.available_for_hire = true
      end
    when 'hiring'
      member.entity = 'company'
      member.job_offers_url = attributes['url']
    when /appsterdammers/
      member.work_location = case attributes['location']
      when /appsterdam/i, /amsterdam/i
        'appsterdam'
      when /nederland/i, /netherlands/i, /holland/i
        'applander'
      else
        'appbroader'
      end
    when 'designers'
      add_work_type(member, 'designer')
    when 'developers'
      add_work_type(member, 'developer')
    when 'founders'
      add_work_type(member, 'management-executive')
    when 'marketeers'
      add_work_type(member, 'marketing')
    end
    
    member.save
  end
end


Classified.create(:placer => Member.first, :offered => true, :category => 'bikes', :title => "I have a spare bike", :description => "I have a bike I don't use. It's a ladies bike, but in Amsterdam it's pretty common for guys to ride a ladies bike. Send me a DM if you're interested.")
Classified.create(:placer => Member.last, :offered => false, :category => 'other', :title => "Looking for beta testers", :description => "We're developing an Android app that used social features and photo's to leverage the user's preferences. We're looking for people to beta test the application. Send an email to sandy@example.com for more information.")
Classified.create(:placer => Member.first, :offered => true, :category => 'housing', :title => "My attic", :description => "I have room in my attic to house people for a short while. There is a spare bed and a mirror. Let me know if you want to use it.")
