build: down up
down: 
	docker compose down --remove-orphans
up:
	docker compose up -d