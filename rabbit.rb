require "bunny"

module Rabbit
  extend self

	def publish(data, routing_key: 'default')
		begin
			conn = Bunny.new(hostname:  ENV.fetch('RABBITMQ_HOST', 'localhost'))
			conn.start
			$ch = conn.create_channel
		rescue StandardError
			sleep 1
			retry
		end unless $ch
		$ch.default_exchange.publish(data, routing_key: routing_key)
	end
end