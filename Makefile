# Start everything in background
all:	
	@docker compose up -d
# See running containers
ps:		
	@docker compose ps
# Stop/remove containers and networks
down:	
	@docker compose down
# Stop/remove containers + volumes
fclean:	
	@docker compose down -v
# remove everything and build new
re:		fclean all
# rebuild containers, keep volume
new:	down
	@docker compose build --no-cache

.PHONY:	all ps down fclean re new