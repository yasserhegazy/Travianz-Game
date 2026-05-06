# TravianZ Installation Guide

Welcome to the TravianZ deployment guide. This document provides step-by-step instructions on how to install and run the game, both locally on your own machine and on the internet using Google Cloud Platform (GCP).

The project is fully containerized using Docker, which eliminates tedious server configuration and automates permission handling.

---

## Part 1: Local Deployment (Your Machine)

Follow these steps to test, develop, or run the game on your personal computer.

### 1. Prerequisites
- **Docker Desktop** (or Docker Engine + Docker Compose for Linux).
- **Git** installed on your system.

### 2. Clone the Repository
Open your terminal (or command prompt) and run:
```bash
git clone https://github.com/Shadowss/TravianZ.git
cd TravianZ
```

### 3. Setup Configuration
Copy the default environment variables file:
```bash
cp .env.example .env
```
*(Optional)* You can open the `.env` file to customize your database passwords, but the defaults are fine for local testing.

### 4. Start the Application
Run the following command to download the dependencies, build the web server, and start the database:
```bash
docker compose up -d --build
```

### 5. Run the Web Installer
Once the containers are running, you must install the database structure and world data. 
Open your web browser and navigate to:
**`http://localhost:8080/install`**

During the wizard, use the following database credentials (unless you changed them in your `.env` file):
- **SQL Hostname:** `db`
- **Port:** `3306`
- **Username:** `travianz`
- **Password:** `travianzpass`
- **DB name:** `travian`
- **Prefix:** `s1_`
- **Type:** `MYSQLi`

Once completed, you can access the game at `http://localhost:8080/`.

> **Note:** The Docker setup includes an automated entrypoint script that handles all file permission issues (`chmod 777`). You do not need to run any manual permission commands.

---

## Part 2: Cloud Deployment (Google Cloud Platform)

To make the game accessible to the public, deploying to a Google Compute Engine (GCE) Virtual Machine is the most robust and cost-effective approach for this Docker-based setup.

### 1. Create a VM Instance on Google Cloud
1. Go to the [Google Cloud Console](https://console.cloud.google.com/).
2. Navigate to **Compute Engine > VM instances**.
3. Click **Create Instance**.
4. Configure your VM:
   - **Name:** `travianz-server`
   - **Region:** Choose a region closest to your expected players.
   - **Machine type:** `e2-medium` (Recommended for smooth performance).
   - **Boot disk:** `Ubuntu 22.04 LTS` (or Debian 11/12) with at least 20GB of standard persistent disk.
5. **Firewall (Crucial Step):** 
   - Check the box for **"Allow HTTP traffic"** (Port 80).
   - Check the box for **"Allow HTTPS traffic"** (Port 443).
6. Click **Create**.

### 2. Connect to the VM and Install Docker
Once the VM is running, click the **SSH** button next to your instance in the Google Cloud Console.

Run the following commands in the SSH terminal to install Docker:
```bash
# Update packages
sudo apt-get update

# Install Docker
sudo apt-get install -y docker.io docker-compose

# Add your user to the docker group so you don't need 'sudo' every time
sudo usermod -aG docker $USER
```
*Note: You may need to disconnect and reconnect the SSH session for the user group change to take effect.*

### 3. Deploy the Game
Run the exact same commands you used for local deployment:
```bash
git clone https://github.com/Shadowss/TravianZ.git
cd TravianZ
cp .env.example .env

# Start the stack
docker-compose up -d --build
```

### 4. Install the Game via the Web
1. Find your VM's **External IP address** in the Google Cloud Console.
2. Open your web browser and navigate to:
   `http://YOUR_EXTERNAL_IP:8080/install`
3. Follow the installation wizard using the same database credentials outlined in Part 1.

### 5. Finalize for Production (Port Mapping)
By default, the `docker-compose.yml` binds the web server to port `8080`. For a production server, players should access the game without typing a port number (Standard HTTP Port 80).

To fix this, edit the `docker-compose.yml` file on your server:
```bash
nano docker-compose.yml
```
Change the web ports section from `"8080:80"` to `"80:80"`:
```yaml
  web:
    ports:
      - "80:80"
```
Save the file and restart the containers:
```bash
docker-compose down
docker-compose up -d
```
You can now access your game globally by just typing `http://YOUR_EXTERNAL_IP` in any browser!
