# Start everything in background
all:
	@sh ./set-secrets-and-environments.sh
	@docker compose up -d
# stop but keep containers
stop:
	@docker compose stop
# remove containers and networks
down:	
	@docker compose down
# Stop/remove containers + volumes
fclean:
	@read -p "Are you sure you want to remove the volumes and all their data? [y/N] " ans; \
	case $$ans in \
		[yY]|[yY][eE][sS]) docker compose down -v ;; \
		*) echo "Cancelled." ;; \
	esac

# remove everything and build new
re:		fclean all
# remove everything + volumes + build images completely from zero
long-re: 	fclean
	@docker compose build --no-cache
	@make all
build-re:	fclean
	@docker compose build
	@make all
# rebuild containers, keep volume, see logs
debug:	down
	@docker compose build
	@docker compose up

# removes all containers and images
long-debug:	down
	@docker rmi db
	@docker rmi nginx
	@docker rmi wordpress
	@make debug

.PHONY:	all stop down fclean re long-re build-re debug long-debug