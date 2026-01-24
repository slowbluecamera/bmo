# BMO Homelab Architecture

## System Overview

```mermaid
graph TB
    subgraph External["External Access"]
        TailscaleNet["Tailscale Network<br/>(VPN)"]
    end

    subgraph Host["BMO Host System"]
        OS["Ubuntu/Debian<br/>Base System"]
        
        subgraph System["System Layer"]
            Users["User Management"]
            Storage["Storage Mounts<br/>/mnt/bmo2"]
            Samba["Samba<br/>(File Sharing)"]
        end
        
        subgraph Container["Container Runtime"]
            Docker["Docker Engine"]
            Python["Python/pip"]
        end
        
        subgraph Orchestration["Container Management"]
            Portainer["Portainer<br/>(Docker UI<br/>Port 9000)"]
            PortainerAPI["Portainer API<br/>Endpoint"]
        end
        
        subgraph Stacks["Docker Stacks"]
            Caddy["🔀 Caddy<br/>(Reverse Proxy<br/>Port 443)"]
            Jellyfin["🎬 Jellyfin<br/>(Media Server)"]
        end
    end

    TailscaleNet -->|Secure Connection| Portainer
    TailscaleNet -->|Secure Connection| Caddy
    
    OS --> System
    OS --> Container
    
    Container --> Docker
    Container --> Python
    
    Docker --> Orchestration
    Orchestration --> Portainer
    Orchestration --> PortainerAPI
    
    Portainer --> Stacks
    PortainerAPI --> Stacks
    
    Docker --> Stacks
    
    System -->|File Access| Samba
    Storage --> Samba
    Storage --> Stacks
    
    Caddy -->|Proxy Rules| Jellyfin
    Caddy -->|TailScale Socket| TailscaleNet

    style Host fill:#e1f5ff
    style System fill:#fff9c4
    style Container fill:#f3e5f5
    style Orchestration fill:#f3e5f5
    style Stacks fill:#e8f5e9
    style External fill:#ffebee
```

## Component Details

| Component | Role | Purpose |
|-----------|------|---------|
| **System** | Base OS & Services | Ubuntu/Debian with user management, storage mounts, and file sharing via Samba |
| **Docker** | Container Runtime | Containerizes applications and services |
| **Portainer** | Container Management UI | Web-based Docker management (Port 9000) |
| **Caddy** | Reverse Proxy | HTTPS reverse proxy for routing traffic to services (Port 443) |
| **Jellyfin** | Media Server | Media library and streaming service |
| **Tailscale** | Networking | Secure VPN access to services outside the local network |
| **Storage** | External Drives | 2TB external storage mounted for media and application data |
| **Samba** | File Sharing | Network file sharing for accessing storage remotely |

## Access Paths

- **Local Management**: SSH to host → Portainer UI (http://bmo.cassowary-harmonic.ts.net:9000)
- **Remote Services**: Tailscale VPN → Caddy reverse proxy (https://bmo.cassowary-harmonic.ts.net) → Jellyfin & other services
- **File Access**: Samba shares accessible from network
- **Direct Container Access**: Portainer API for automated stack deployment

## Deployment Strategy

All services are deployed as Docker Compose stacks through Portainer, enabling:
- Easy service management and updates
- Persistent configuration and data storage
- Network isolation between containers
- Automated backup and restoration capabilities
