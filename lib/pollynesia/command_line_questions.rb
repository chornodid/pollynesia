require 'highline/import'
require 'pollynesia/patterns'

module Pollynesia
  module CommandLineQuestions
    def self.firstname
      ask('Firstname: ') do |q|
        q.validate = /\S+/
        q.responses[:not_valid] = 'Please provide firstname.'
      end
    end

    def self.lastname
      ask('Lastname: ') do |q|
        q.validate = /\S+/
        q.responses[:not_valid] = 'Please provide lastname.'
      end
    end

    def self.email
      ask('Email: ') do |q|
        q.validate = Pollynesia::Patterns::EMAIL
        q.responses[:not_valid] = 'Invalid email! Please provide valid one.'
      end
    end

    def self.password(params = {})
      ask('Password: ') do |q|
        q.echo = '*'
        q.validate = params[:pattern] || /\S+/
        q.responses[:not_valid] = params[:message] || 'Please provide password.'
      end
    end
  end
end
