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
			sudo rm -rf /home/zpalotas/data/mariadb; \
			sudo rm -rf /home/zpalotas/data/wordpress; \
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
# remove everything + volumes + set new credentials + build images completely from zero
long-re: 	fclean
	@rm -f secrets/secret*
	@rm -f srcs/.env
	@sh ./set-secrets-and-environments.sh
	@$(COMPOSE) build --no-cache
	@$(COMPOSE) up -d 

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

.PHONY:	all stop down fclean re long-re debug long-debug