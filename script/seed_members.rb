Dir.glob(Rails.root + 'db/seeds/*.json').each do |file|
  list_name = File.basename(file, '.json').split('-').first
  list = JSON.parse(File.read(file))
  users = list['users']
  users.each do |attributes|
    member = Member.find_by_twitter_id(attributes['id'].to_s) || Member.create_with_twitter_user_attributes(attributes)
    member.save
  end
end

