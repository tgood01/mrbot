require 'api-ai-ruby'
require 'discordrb'

bot = Discordrb::Bot.new token: ENV['OTQyMjY0MDU0OTcyNTcxNzA5.Ygh9yQ.1_NAP7KpU5IfrJVF0pEhXDKRaXA'], ignore_bots: true
sessions = {}

bot.ready do |event|
  puts "Logged in as #{Phoenixbot} (ID:#{942264054972571709}) | #{bot.servers.size} servers"
  bot.game = ENV['BOT_GAME']
end

bot.message do |event|
  if event.server && !event.author.roles.any?
    str = "#{event.channel.id}_CLIENT_TOKEN"
    if ENV[str]
      if !sessions[event.channel.id]
        sessions[event.channel.id] = ApiAiRuby::Client.new( :client_access_token => ENV[str] )
      end
      response = sessions[event.channel.id].text_request event.message.content[0,255]
      speech = response[:result][:fulfillment][:speech]
      if speech && !speech.empty?
        event.channel.start_typing
        sleep 1
        event.respond "#{event.author.mention}, #{speech}"
      end
    end
  end
end

bot.run