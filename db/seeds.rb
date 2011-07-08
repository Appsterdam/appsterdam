twitter_client ||= TwitterOAuth::Client.new
%w(appsterdamrs fngtps thijs alloy).each do |user|
  if attributes = twitter_client.show(user)
    Member.create_with_twitter_user_attributes(attributes)
  end
end