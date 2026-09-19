COMPOSE_FILE	:= srcs/docker-compose.yml
ENV_FILE		:= srcs/.env
COMPOSE			:= docker compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE)

# Start everything in background
all:
	@sh ./set-secrets-and-environments.sh
	@$(COMPOSE) up -d --build
# stop but keep containers
stop:
	@$(COMPOSE) stop
# remove containers and networks
down:	
	@$(COMPOSE) down
# Stop/remove containers + volumes
fclean:
	@read -p "Are you sure you want to remove the volumes and all their data? [y/N] " ans; \
	case $$ans in \
		[yY]|[yY][eE][sS]) \
			containers=$$(docker ps -qa); \
			if [ -n "$$containers" ]; then docker stop $$containers; docker rm $$containers; fi; \
			images=$$(docker images -qa); \
			if [ -n "$$images" ]; then docker rmi -f $$images; fi; \
			volumes=$$(docker volume ls -q); \
			if [ -n "$$volumes" ]; then docker volume rm $$volumes; fi; \
			networks=$$(docker network ls -q); \
			if [ -n "$$networks" ]; then docker network rm $$networks 2>/dev/null || true; fi; \
			;; \
		*) echo "Cancelled." ;; \
	esac

# remove everything and build new
re:		fclean all
# remove everything + volumes + build images completely from zero
long-re: 	fclean
	@$(COMPOSE) build --no-cache
	@make all
build-re:	fclean
	@$(COMPOSE) build
	@make all
# rebuild containers, keep volume, see logs
debug:	down
	@$(COMPOSE) build
	@$(COMPOSE) up

# removes all containers and images
long-debug:	down
	@docker rmi db
	@docker rmi nginx
	@docker rmi wordpress
	@make debug

.PHONY:	all stop down fclean re long-re build-re debug long-debug