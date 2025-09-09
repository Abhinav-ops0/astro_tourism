# Astro Tourism - Deployment Makefile
# Provides convenient commands for building, deploying, and managing the application

.PHONY: help build deploy start stop restart logs clean test health backup

# Default target
help:
	@echo "🌌 Astro Tourism Deployment Commands"
	@echo "=================================="
	@echo ""
	@echo "Development:"
	@echo "  dev-frontend    Start frontend development server"
	@echo "  dev-backend     Start backend development server"
	@echo "  dev-full        Start full development environment"
	@echo ""
	@echo "Production:"
	@echo "  build           Build all Docker images"
	@echo "  deploy          Deploy application to production"
	@echo "  start           Start all services"
	@echo "  stop            Stop all services"
	@echo "  restart         Restart all services"
	@echo ""
	@echo "Monitoring:"
	@echo "  logs            View application logs"
	@echo "  logs-f          Follow application logs"
	@echo "  health          Check application health"
	@echo "  status          Show container status"
	@echo ""
	@echo "Maintenance:"
	@echo "  clean           Clean up Docker resources"
	@echo "  backup          Create application backup"
	@echo "  update          Update application from git"
	@echo "  reset           Reset application (clean slate)"
	@echo ""

# Development commands
dev-frontend:
	@echo "🚀 Starting frontend development server..."
	cd frontend && npm run dev

dev-backend:
	@echo "🐍 Starting backend development server..."
	cd backend && source venv/bin/activate && python app.py

dev-full:
	@echo "🔧 Starting full development environment..."
	docker-compose -f docker-compose.yml up --build

# Production commands
build:
	@echo "🏗️  Building Docker images..."
	docker-compose -f docker-compose.yml -f docker-compose.prod.yml build --no-cache

deploy: build
	@echo "🚀 Deploying Astro Tourism application..."
	./scripts/deploy.sh

start:
	@echo "▶️  Starting all services..."
	docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d

stop:
	@echo "⏹️  Stopping all services..."
	docker-compose -f docker-compose.yml -f docker-compose.prod.yml down

restart: stop start
	@echo "🔄 Services restarted"

# Monitoring commands
logs:
	@echo "📋 Showing recent logs..."
	docker-compose logs --tail=100

logs-f:
	@echo "📋 Following logs (Ctrl+C to exit)..."
	docker-compose logs -f

health:
	@echo "🏥 Checking application health..."
	@echo "Main health check:"
	@curl -f http://localhost/health && echo "✅ Main service healthy" || echo "❌ Main service unhealthy"
	@echo "API health check:"
	@curl -f http://localhost/api/health && echo "✅ API service healthy" || echo "❌ API service unhealthy"

status:
	@echo "📊 Container status:"
	docker-compose ps

# Maintenance commands
clean:
	@echo "🧹 Cleaning up Docker resources..."
	docker-compose down --remove-orphans
	docker system prune -f
	docker volume prune -f

backup:
	@echo "💾 Creating application backup..."
	@mkdir -p backups
	tar -czf backups/astro_tourism_backup_$(shell date +%Y%m%d_%H%M%S).tar.gz \
		--exclude=node_modules \
		--exclude=venv \
		--exclude=.git \
		--exclude=backups \
		.
	@echo "✅ Backup created in backups/ directory"

update:
	@echo "🔄 Updating application from git..."
	git pull origin main
	$(MAKE) build
	$(MAKE) restart
	@echo "✅ Application updated"

reset: stop clean
	@echo "🔄 Resetting application..."
	docker-compose -f docker-compose.yml -f docker-compose.prod.yml build --no-cache
	$(MAKE) start
	@echo "✅ Application reset complete"

# Testing commands
test-frontend:
	@echo "🧪 Running frontend tests..."
	cd frontend && npm test

test-backend:
	@echo "🧪 Running backend tests..."
	cd backend && source venv/bin/activate && python -m pytest

test: test-frontend test-backend
	@echo "✅ All tests completed"

# SSL setup (for production with domain)
ssl-setup:
	@echo "🔒 Setting up SSL certificate..."
	sudo certbot --nginx -d $(DOMAIN) -d www.$(DOMAIN)

# Quick deployment check
check-deployment:
	@echo "🔍 Checking deployment..."
	@echo "Containers:"
	@docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
	@echo ""
	@echo "Health checks:"
	@$(MAKE) health
	@echo ""
	@echo "Public IP: $(shell curl -s http://169.254.169.254/latest/meta-data/public-ipv4 2>/dev/null || echo 'Not on EC2')"

# Install prerequisites
install-prereqs:
	@echo "📦 Installing prerequisites..."
	sudo apt update
	sudo apt install -y docker.io docker-compose git curl
	sudo usermod -aG docker $$USER
	@echo "✅ Prerequisites installed. Please logout and login again."

# Environment setup
setup-env:
	@echo "⚙️  Setting up environment..."
	@if [ ! -f .env ]; then \
		cp .env.example .env; \
		echo "📝 Created .env file from template. Please edit it with your values."; \
	else \
		echo "✅ .env file already exists"; \
	fi