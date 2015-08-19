namespace :db do
  desc 'Create admin user'
  task create_admin_user: :environment do
    require 'create_admin_user_service'
    require 'pollynesia/command_line_questions'

    attrs = %i(firstname lastname email password).map do |key|
      value = Pollynesia::CommandLineQuestions.send(key)
      [key, value]
    end.to_h

    service = Service::CreateAdminUser.new(attrs)
    begin
      user = service.call
    rescue => e
      say "ERROR: #{e.inspect}"
      return
    end
    say 'Admin user has been successfully created!' if user
  end
end
