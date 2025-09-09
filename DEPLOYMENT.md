# Comprehensive deployment guide for Astro Tourism on Amazon EC2

# 🚀 AWS EC2 Deployment Guide for Astro Tourism

## Prerequisites

### 1. AWS Account Setup
- AWS account with EC2 access
- Key pair for SSH access
- Security group configured

### 2. Local Requirements
- Git installed
- SSH client
- Domain name (optional, for production)

## EC2 Instance Setup

### 1. Launch EC2 Instance

**Recommended Configuration:**
```
Instance Type: t3.medium (2 vCPU, 4 GB RAM)
AMI: Ubuntu 22.04 LTS
Storage: 20 GB gp3
Security Group: Custom (see below)
```

**Security Group Rules:**
```
Type        Protocol    Port    Source
SSH         TCP         22      Your IP/0.0.0.0/0
HTTP        TCP         80      0.0.0.0/0
HTTPS       TCP         443     0.0.0.0/0
Custom TCP  TCP         8080    0.0.0.0/0 (optional, for monitoring)
```

### 2. Connect to Instance
```bash
# Replace with your key file and instance IP
ssh -i your-key.pem ubuntu@your-ec2-public-ip
```

### 3. Initial Server Setup
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Download setup script
wget https://raw.githubusercontent.com/your-repo/astro_tourism/main/scripts/setup-ec2.sh
chmod +x setup-ec2.sh

# Run setup script
sudo ./setup-ec2.sh
```

## Application Deployment

### 1. Clone Repository
```bash
# Navigate to application directory
cd /opt/astro_tourism

# Clone your repository
sudo git clone https://github.com/your-username/astro_tourism.git .
sudo chown -R ubuntu:ubuntu /opt/astro_tourism
```

### 2. Configure Environment
```bash
# Copy environment template
cp .env.example .env

# Edit environment variables
nano .env
```

### 3. Deploy Application
```bash
# Run deployment script
./scripts/deploy.sh
```

### 4. Verify Deployment
```bash
# Check container status
docker-compose ps

# View logs
docker-compose logs -f

# Test endpoints
curl http://localhost/health
curl http://localhost/api/health
```

## Domain Configuration (Optional)

### 1. DNS Setup
- Point your domain A record to EC2 public IP
- Create CNAME for www subdomain

### 2. SSL Certificate (Let's Encrypt)
```bash
# Install certbot
sudo apt install certbot python3-certbot-nginx

# Get certificate
sudo certbot --nginx -d your-domain.com -d www.your-domain.com

# Test auto-renewal
sudo certbot renew --dry-run
```

## Monitoring and Maintenance

### 1. System Monitoring
```bash
# View system resources
htop

# Check disk usage
df -h

# Monitor logs
tail -f /var/log/syslog
```

### 2. Application Monitoring
```bash
# Container status
docker ps

# Application logs
docker-compose logs -f nginx
docker-compose logs -f frontend
docker-compose logs -f backend

# Resource usage
docker stats
```

### 3. Backup Strategy
```bash
# Backup application data
sudo tar -czf backup-$(date +%Y%m%d).tar.gz /opt/astro_tourism

# Backup to S3 (optional)
aws s3 cp backup-$(date +%Y%m%d).tar.gz s3://your-backup-bucket/
```

## Troubleshooting

### Common Issues

**1. Containers not starting:**
```bash
# Check logs
docker-compose logs

# Rebuild containers
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

**2. Port conflicts:**
```bash
# Check what's using port 80
sudo lsof -i :80

# Stop conflicting services
sudo systemctl stop apache2  # if Apache is running
```

**3. Permission issues:**
```bash
# Fix Docker permissions
sudo usermod -aG docker ubuntu
newgrp docker

# Fix file permissions
sudo chown -R ubuntu:ubuntu /opt/astro_tourism
```

**4. Out of disk space:**
```bash
# Clean Docker
docker system prune -a

# Remove old logs
sudo journalctl --vacuum-time=7d
```

### Health Checks

**Application Health:**
- Main app: `http://your-domain/health`
- API: `http://your-domain/api/health`
- Container status: `docker-compose ps`

**System Health:**
- CPU/Memory: `top` or `htop`
- Disk usage: `df -h`
- Network: `netstat -tulpn`

## Performance Optimization

### 1. Server Optimization
```bash
# Increase file limits
echo "* soft nofile 65536" | sudo tee -a /etc/security/limits.conf
echo "* hard nofile 65536" | sudo tee -a /etc/security/limits.conf

# Optimize kernel parameters
echo "net.core.somaxconn = 65536" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

### 2. Application Optimization
- Enable Gzip compression (already configured)
- Use CDN for static assets
- Implement caching headers
- Monitor and optimize database queries

### 3. Cost Optimization
- Use spot instances for development
- Implement auto-scaling groups
- Set up CloudWatch billing alerts
- Regular cost analysis

## Security Best Practices

### 1. Server Security
```bash
# Configure firewall
sudo ufw enable
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https

# Disable password authentication
sudo nano /etc/ssh/sshd_config
# Set: PasswordAuthentication no
sudo systemctl restart ssh
```

### 2. Application Security
- Regular security updates
- Use environment variables for secrets
- Implement rate limiting (already configured)
- Regular security scans

### 3. Network Security
- Use VPC with private subnets
- Implement WAF for additional protection
- Regular security group audits

## Scaling Considerations

### 1. Horizontal Scaling
- Use Application Load Balancer
- Multiple EC2 instances
- Auto Scaling Groups

### 2. Vertical Scaling
- Upgrade instance type as needed
- Monitor CPU/Memory usage
- Optimize application performance

### 3. Database Scaling (Future)
- RDS for managed database
- Read replicas for read scaling
- Connection pooling

## Maintenance Schedule

### Daily
- Check application health
- Review error logs
- Monitor resource usage

### Weekly
- Security updates
- Log rotation
- Backup verification

### Monthly
- Full system backup
- Security audit
- Performance review
- Cost optimization review

---

## Quick Reference Commands

```bash
# Start application
sudo systemctl start astro-tourism

# Stop application
sudo systemctl stop astro-tourism

# Restart application
sudo systemctl restart astro-tourism

# View application status
sudo systemctl status astro-tourism

# View real-time logs
docker-compose logs -f

# Update application
git pull origin main
docker-compose build --no-cache
docker-compose up -d

# Emergency stop
docker-compose down
```

## Support

For issues and questions:
1. Check application logs: `docker-compose logs`
2. Check system logs: `sudo journalctl -u astro-tourism`
3. Review this deployment guide
4. Check GitHub issues
5. Contact system administrator

---

**🌟 Your Astro Tourism application is now ready to explore the cosmos!**