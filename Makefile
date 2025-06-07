.PHONY: help kill

status:
	docker compose ps

stop:
	docker compose stop

clean:
	docker compose rm --stop

destroy:
	docker compose rm --stop
	docker rmi -f $(shell docker compose images -q)
	docker volume rm lxp_db
	sudo rm -rf app/_build app/deps

restart:
	docker compose stop
	docker compose up --build -d

up:
	docker compose up --build -d
	sleep 5
	docker compose ps

logs:
	docker compose logs -f

compile:
	make stop
	sudo rm -rf app/_build app/deps
	make up

ecto.reset:
	docker compose exec -it app /bin/bash -ci "mix ecto.reset"

iex:
	docker compose exec -it app /bin/bash -ci "iex --sname console --cookie fractalup --remsh node"

shell:
	docker compose exec -it app /bin/sh