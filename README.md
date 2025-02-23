# Load Balancer with Nginx and Node-RED

## Overview
This project sets up a load balancer using Nginx with three Node-RED instances acting as backend services. The load balancer distributes requests to the backend services using the **Round Robin** method.

## API Endpoint
The application provides an API endpoint to fetch temperature data from one of the backend services:

```
GET /api/temperature
```

### Sample Response:
```json
{
  "temperature": 27.5,
  "unit": "Celsius",
  "server": "server-1"
}
```

The response will include the temperature reading along with the server that processed the request.

## Project Structure
- **Nginx** acts as the load balancer
- **Node-RED** instances simulate temperature sensors
- **Docker Compose** manages container orchestration

## Running the Project
### Prerequisites
Ensure you have Docker and Docker Compose installed on your machine.

### Steps to Run
1. Clone the repository:
   ```sh
   git clone <repository-url>
   cd <project-directory>
   ```

2. Build and start the services using Makefile:
   ```sh
   make build
   ```

3. Alternatively, start and stop services manually:
   - Start services:
     ```sh
     make up
     ```
   - Stop services:
     ```sh
     make down
     ```

4. Access the temperature API via:
   ```sh
   curl http://localhost/api/temperature
   ```

5. Access Node-RED instances via:
   - `http://localhost:1880` (temp-sensor-1)
   - `http://localhost:1881` (temp-sensor-2)
   - `http://localhost:1882` (temp-sensor-3)

## Configuration Details

### Docker Compose Setup
The `docker-compose.yml` file defines:
- **Nginx** as the load balancer
- **Three Node-RED containers** acting as temperature services
- **Volume management** for persistent Node-RED data


### Nginx Configuration
Nginx is configured to use **Round Robin** to distribute traffic evenly among the three Node-RED instances.

```nginx
http {
    upstream backend_servers { 
        server temp-sensor-3:1880;
        server temp-sensor-2:1880;
        server temp-sensor-1:1880;
    }

    server {
        listen 80;
        server_name localhost;

        location / {
            proxy_pass http://backend_servers;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
    }
}
```

## Notes
- The load balancer will distribute incoming requests in a Round Robin fashion among the three Node-RED instances.
- Detailed logs can be found in `/var/log/nginx/error.log` (change logging level if needed).


