# Docker Setup Guide for Qasim Jutt's Portfolio

## Prerequisites
- Install Docker Desktop from https://www.docker.com/products/docker-desktop
- Ensure Docker Desktop is running

## Building the Docker Image

```bash
# Navigate to the project directory
cd qasim-jutt-portfolio

# Build the Docker image
docker build -t qasim-portfolio:latest .

# Or use docker-compose to build
docker-compose build
```

## Running the Container

### Using Docker directly:
```bash
# Run the container
docker run -p 3000:3000 qasim-portfolio:latest

# Run with environment variables
docker run -p 3000:3000 -e NODE_ENV=production qasim-portfolio:latest

# Run in detached mode
docker run -d -p 3000:3000 --name portfolio-app qasim-portfolio:latest
```

### Using Docker Compose:
```bash
# Start the application
docker-compose up

# Start in detached mode
docker-compose up -d

# View logs
docker-compose logs -f

# Stop the application
docker-compose down
```

## Accessing the Application
Once running, the application will be available at: **http://localhost:3000**

## Useful Docker Commands

### View running containers
```bash
docker ps
```

### View all containers (including stopped)
```bash
docker ps -a
```

### View image list
```bash
docker images
```

### Stop a container
```bash
docker stop <container_id>
```

### Remove a container
```bash
docker rm <container_id>
```

### View container logs
```bash
docker logs <container_id>
```

### Remove an image
```bash
docker rmi qasim-portfolio:latest
```

## Image Details
- **Base Image**: node:16-alpine (lightweight Linux with Node.js 16)
- **Port**: 3000
- **Build Strategy**: Multi-stage build (builder + production stages)
- **Size**: Optimized for production with only necessary dependencies

## Docker Compose Services
- **portfolio**: Main Next.js application service
  - Ports: 3000:3000
  - Environment: NODE_ENV=production
  - Auto-restart: unless-stopped

## Environment Variables
You can set environment variables in docker-compose.yml:
- `NODE_ENV`: Set to 'production' for production builds
- `NEXT_PUBLIC_API_URL`: Public API URL for the application

## Troubleshooting

### "Docker daemon is not running"
- Start Docker Desktop from your applications

### "Port 3000 is already in use"
```bash
# Use a different port
docker run -p 3001:3000 qasim-portfolio:latest
```

### "npm install fails in Docker"
- Check your internet connection
- Try building with `--no-cache`: `docker build --no-cache -t qasim-portfolio:latest .`

### "Build fails with memory issues"
- Allocate more memory to Docker Desktop (Docker Desktop Settings → Resources)
