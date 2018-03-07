
restart: stop start

start:
	bundle exec passenger start --daemonize --address 127.0.0.1 --port 4000

stop:
	bundle exec passenger stop --port 4000

