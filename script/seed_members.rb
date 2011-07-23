Dir.glob(Rails.root + 'db/seeds/*.json').each do |file|
  list_name = File.basename(file, '.json').split('-').first
  list = JSON.parse(File.read(file))
  users = list['users']
  users.each do |attributes|
    member = Member.find_by_twitter_id(attributes['id'].to_s) || Member.create_with_twitter_user_attributes(attributes)

    # TODO Check for better way of setting properties in seed
    member.entity = case list_name
    when "companies" then "company"
    when "students" then "student"
    when "collectives" then "group"
    else
      "individual"
    end

    member.work_location = "appsterdam" if list_name == "appsterdammers"

    
    member.work_types = member.work_types.push 
    
    member.work_types = member.work_types << case list_name
    when "designers" then "design"
    when "developers" then "developer"
    when "marketeers" then "marketing"
    else
      nil
    end

    member.available_for_hire = true if list_name == "available"

    member.save
  end
end

