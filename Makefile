.PHONY: build clean test psql createdb dropdb migrate migrateup migratedown migratestatus

psql:
	docker run --name postgres12  \
	-e POSTGRES_PASSWORD=secret \
	-e POSTGRES_USER=root \
	-e POSTGRES_DB=simple_bank \
	-p 5432:5432 \
	-d postgres:12-alpine

createdb:
	docker exec -it postgres12 createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres12 dropdb simple_bank

psql-it:
	docker exec -it postgres12 psql -U root -d simple_bank

# Run only once, to create migration init-schema
first-migrate:
	migrate create -ext sql -dir db/migrations -seq init-schema

migrate-up:
	migrate -path db/migrations -database "postgres://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up

migrate-down:
	migrate -path db/migrations -database "postgres://root:secret@loca=host:5432/simple_bank?sslmode=disable" -verbose down

migrate-status:
	migrate -path db/migrations -database "postgres://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose status