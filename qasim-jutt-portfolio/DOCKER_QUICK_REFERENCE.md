# Docker Quick Reference - Qasim Jutt's Portfolio

## One-Command Setup

```bash
# Build and run container
docker-compose up -d

# Access application
# Open browser to: http://localhost:3000

# View logs
docker-compose logs -f

# Stop container
docker-compose down
```

## Complete Command List

### Building
```bash
# Build image with Docker
docker build -t qasim-portfolio:latest .

# Build with Docker Compose
docker-compose build

# Build without cache
docker build --no-cache -t qasim-portfolio:latest .
```

### Running
```bash
# Run with docker-compose
docker-compose up              # Foreground
docker-compose up -d           # Background

# Run with docker directly
docker run -p 3000:3000 qasim-portfolio:latest
docker run -d -p 3000:3000 --name portfolio qasim-portfolio:latest

# Run with custom port
docker run -p 3001:3000 qasim-portfolio:latest
```

### Monitoring
```bash
# View running containers
docker ps

# View all containers
docker ps -a

# View container logs
docker logs <container_id>
docker logs -f <container_id>          # Follow logs
docker logs --tail 50 <container_id>   # Last 50 lines

# View with Docker Compose
docker-compose logs
docker-compose logs -f
docker-compose logs --tail 50
```

### Stopping & Removing
```bash
# Stop container
docker stop <container_id>

# Stop with timeout
docker stop -t 30 <container_id>

# Remove container
docker rm <container_id>

# Stop and remove with Docker Compose
docker-compose down

# Remove image
docker rmi qasim-portfolio:latest

# Force remove
docker rmi -f qasim-portfolio:latest

# Remove all stopped containers
docker container prune

# Remove all unused images
docker image prune
```

### Inspection
```bash
# Inspect image
docker inspect qasim-portfolio:latest

# View image layers
docker history qasim-portfolio:latest

# Inspect container
docker inspect <container_id>

# Get container IP
docker inspect -f '{{.NetworkSettings.IPAddress}}' <container_id>
```

### Debugging
```bash
# Shell into running container
docker exec -it <container_id> sh
docker exec -it <container_id> /bin/sh

# Run command in container
docker exec <container_id> npm list

# View stats (CPU, memory)
docker stats <container_id>

# View processes in container
docker top <container_id>
```

### Images & Registries
```bash
# List images
docker images

# View image size
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"

# Tag image for registry
docker tag qasim-portfolio:latest username/qasim-portfolio:latest

# Push to registry (Docker Hub)
docker push username/qasim-portfolio:latest
```

## Troubleshooting Commands

```bash
# Check Docker installation
docker --version

# Check Docker daemon
docker info

# Test Docker
docker run hello-world

# Restart Docker daemon
# Windows: Restart Docker Desktop application
# Linux: sudo systemctl restart docker

# Check port usage
netstat -ano | findstr :3000   # Windows
lsof -i :3000                   # Mac/Linux

# View Docker disk usage
docker system df

# Clean up everything unused
docker system prune -a

# Rebuild without using cache
docker-compose up -d --build --no-cache
```

## File Structure for Docker

```
qasim-jutt-portfolio/
├── Dockerfile              # Multi-stage build definition
├── docker-compose.yml      # Docker Compose setup
├── .dockerignore          # Files to exclude from build
├── package.json           # Dependencies
├── next.config.js         # Next.js config
├── tsconfig.json          # TypeScript config
├── src/                   # Source code
│   ├── components/
│   ├── pages/
│   ├── styles/
│   └── types/
├── public/                # Static files
└── DOCKER_SETUP.md        # Detailed Docker guide
```

## Performance Tips

```bash
# Limit container memory
docker run -m 512m -p 3000:3000 qasim-portfolio:latest

# Set CPU limits
docker run --cpus 1 -p 3000:3000 qasim-portfolio:latest

# Check actual container size
docker ps --format "table {{.Names}}\t{{.Size}}\t{{.RunningFor}}"
```

## Environment Variables in Docker

```yaml
# Set in docker-compose.yml
environment:
  - NODE_ENV=production
  - NEXT_PUBLIC_API_URL=http://localhost:3000

# Or from file
env_file:
  - .env

# Or from command line
docker run -e NODE_ENV=production qasim-portfolio:latest
```

## Next.js Specific

```bash
# Inside container
docker exec <container_id> npm run build    # Build app
docker exec <container_id> npm test         # Run tests
docker exec <container_id> npm run dev      # Dev mode (if modified)
```

## Docker Compose Specific

```bash
# Create and start containers
docker-compose up

# Create and start in background
docker-compose up -d

# Build and start
docker-compose up -d --build

# Stop services gracefully
docker-compose stop

# Stop and remove (keeps volumes)
docker-compose down

# Stop and remove everything (including volumes)
docker-compose down -v

# View service status
docker-compose ps

# View logs
docker-compose logs

# Follow logs
docker-compose logs -f

# Remove images
docker-compose down --rmi all

# Execute command in service
docker-compose exec portfolio sh
```

## Production Deployment Checklist

- [ ] Build image: `docker build -t qasim-portfolio:1.0.0 .`
- [ ] Tag for registry: `docker tag qasim-portfolio:1.0.0 registry.com/portfolio:1.0.0`
- [ ] Push to registry: `docker push registry.com/portfolio:1.0.0`
- [ ] Update docker-compose.yml with latest image tag
- [ ] Set production environment variables
- [ ] Configure health checks if needed
- [ ] Set up persistent volumes for data
- [ ] Configure logging drivers
- [ ] Set resource limits (memory, CPU)
- [ ] Test in staging environment first

---

## Useful Links

- Docker Docs: https://docs.docker.com/
- Next.js Docker Guide: https://nextjs.org/docs/deployment/docker
- Docker Compose: https://docs.docker.com/compose/
- Docker Hub: https://hub.docker.com/
