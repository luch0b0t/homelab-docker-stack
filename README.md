# Homelab Docker Stack

A comprehensive Docker Compose stack for personal homelab services. This repository contains various self-hosted applications organized in separate directories for easy management and deployment.

## 🏗️ Architecture

The stack is organized into service-specific directories, each containing its own `docker-compose.yml` file. This modular approach allows for independent management of each service while maintaining a cohesive deployment strategy.

## 📋 Services Overview

### 🌐 Reverse Proxy & Networking
- **Caddy** - Modern web server with automatic HTTPS
  - Port: 80, 443
  - Provides reverse proxy for local services
  - Automatic SSL certificate management

### 📊 Monitoring & Management
- **Homepage** - Application dashboard and launcher
  - Port: 3001
  - Centralized access to all services
  - Real-time monitoring widgets
  - Data persistence: `/opt/docker-data/homepage`

- **Grafana** - Open-source analytics and monitoring platform
  - Port: 3000
  - Data persistence: `/opt/docker-data/grafana`
  
- **Portainer** - Container management web interface
  - Port: 9000
  - Docker socket access for container management
  - Data persistence: `/opt/docker-data/portainer`

### 🎬 Media Management
- **Jellyfin** - Media server for organizing and streaming media
  - Network Mode: Host
  - Media directory: `/mnt/media` (read-only)
  - Persistent configuration and cache volumes

- **Media Stack** (Complete media management suite):
  - **Jackett** - Torrent indexer proxy (Port: 9117)
  - **Sonarr** - TV series management (Port: 8989)
  - **Radarr** - Movie management (Port: 7878)
  - **Transmission** - Torrent client (Port: 9091, 51413)
  - Shared directories: `/mnt/media`, `/mnt/torrents`

### 🛠️ Productivity & Automation
- **n8n** - Workflow automation tool
  - Port: 5678
  - Basic authentication enabled
  - Custom domain: n8n.local
  - Runners enabled for enhanced performance

- **Excalidraw** - Virtual whiteboard for diagramming
  - Port: 5000
  - Collaborative drawing tool

### 🔒 Network & Security
- **Pi-hole** - DNS-based ad blocker
  - DNS Ports: 53 (TCP/UDP)
  - Web Interface: Custom port via `${PIHOLE_WEBPORT}`
  - DNS servers: 127.0.0.1, 1.1.1.1

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose installed
- Sufficient disk space for persistent data
- Appropriate user permissions for Docker

### Environment Configuration
Create a `.env` file in the root directory with the following variables:

```bash
# Timezone
TZ=America/Santiago

# User/Group ID for container permissions
PUID=1000
PGID=1000

# n8n Authentication
N8N_BASIC_AUTH_USER=your_username
N8N_BASIC_AUTH_PASSWORD=your_password
N8N_SECURE_COOKIE=true

# Pi-hole
PIHOLE_WEBPASSWORD=your_admin_password
PIHOLE_WEBPORT=8080
PIHOLE_API_KEY=your_pihole_api_key

# Homepage Services API Keys (Optional - for enhanced widgets)
GRAFANA_PASSWORD=your_grafana_password
JELLYFIN_API_KEY=your_jellyfin_api_key
SONARR_API_KEY=your_sonarr_api_key
RADARR_API_KEY=your_radarr_api_key
JACKETT_API_KEY=your_jackett_api_key
PORTAINER_ENDPOINT=your_portainer_endpoint
PORTAINER_API_KEY=your_portainer_api_key
```

### Directory Setup
Create required directories for persistent data:

```bash
sudo mkdir -p /opt/docker-data/{grafana,portainer,homepage}
sudo mkdir -p /mnt/{media,torrents}
sudo chown -R $USER:$USER /opt/docker-data
```

### Deployment Options

#### Option 1: Individual Service Deployment
Navigate to any service directory and run:
```bash
cd [service-directory]
docker-compose up -d
```

#### Option 2: Automated Deployment (Recommended)
Use the provided deployment script:
```bash
chmod +x deploy.sh
./deploy.sh
```

The deployment script:
- Loads environment variables from `.env`
- Handles private registry authentication (if `~/.ghcr_env` exists)
- Pulls latest changes from Git
- Detects modified directories and rebuilds only changed services
- Automatically restarts updated services

## 🔧 Configuration Details

### Caddy Reverse Proxy
The Caddy configuration routes local domains to internal services:
- `homepage.local` → Homepage dashboard (port 3001)
- `n8n.local` → n8n service (port 5678)
- `jellyfin.local` → Jellyfin service (port 8096)
- `omv.local` → OpenMediaVault (port 81)

### Media Stack Integration
The media services are designed to work together:
1. **Jackett** searches and provides torrent trackers
2. **Sonarr** monitors and downloads TV series
3. **Radarr** monitors and downloads movies
4. **Transmission** handles the actual torrent downloads

All services share common download and media directories for seamless integration.

### Authentication & Security
- **n8n**: Basic authentication via environment variables
- **Pi-hole**: Admin interface password protected
- **Caddy**: Automatic HTTPS with Let's Encrypt certificates
- All services run with non-root user where possible

## 📁 File Structure
```
homelab-docker-stack/
├── caddy/
│   ├── docker-compose.yml
│   └── Caddyfile
├── excalidraw/
│   └── docker-compose.yml
├── grafana/
│   └── docker-compose.yml
├── homepage/
│   ├── docker-compose.yml
│   └── settings.yaml
├── jellyfin/
│   └── docker-compose.yml
├── media/
│   └── docker-compose.yml
├── n8n/
│   └── docker-compose.yml
├── pihole/
│   └── docker-compose.yml
├── portainer/
│   └── docker-compose.yml
├── .env.example
├── .gitignore
├── deploy.sh
└── README.md
```

## 🔄 Maintenance

### Updates
To update all services:
```bash
./deploy.sh
```

To update a specific service:
```bash
cd [service-directory]
docker-compose pull
docker-compose up -d
```

### Backup
Regularly backup the persistent data directories:
- `/opt/docker-data/`
- Any custom configuration files

### Logs
View logs for any service:
```bash
docker-compose -f [service-directory]/docker-compose.yml logs -f
```

## 🌐 Access URLs

After deployment, access services via:
- **Homepage**: `http://localhost:3001` or `http://homepage.local` (main dashboard)
- **Grafana**: `http://localhost:3000`
- **Portainer**: `http://localhost:9000`
- **n8n**: `http://localhost:5678` or `http://n8n.local` (if DNS configured)
- **Jellyfin**: `http://localhost:8096` or `http://jellyfin.local`
- **Excalidraw**: `http://localhost:5000`
- **Pi-hole**: `http://localhost:${PIHOLE_WEBPORT}/admin`
- **Jackett**: `http://localhost:9117`
- **Sonarr**: `http://localhost:8989`
- **Radarr**: `http://localhost:7878`
- **Transmission**: `http://localhost:9091`

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## ⚠️ Important Notes

- Ensure proper firewall configuration for exposed ports
- Regularly update container images for security
- Backup configuration data before major updates
- Monitor disk space usage, especially for media and torrent directories
- Some services require additional initial configuration through their web interfaces

## 🆘 Troubleshooting

### Common Issues
1. **Port conflicts**: Check if ports are already in use
2. **Permission errors**: Verify user ID/GID settings in `.env`
3. **DNS issues**: Ensure local DNS resolution for `.local` domains
4. **Volume mounting**: Verify directory paths and permissions

### Getting Help
- Check container logs: `docker logs [container-name]`
- Verify service status: `docker ps`
- Check system resources: `docker system df`