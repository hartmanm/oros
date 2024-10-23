# Scripts for oros Operating System used as part of openrig.net

## Overview

**openrig.net** was previously a service designed for easily managing large numbers of cryptocurrency GPU mining rigs. It allows for centralized configuration and management, eliminating the need to manually adjust settings on each individual rig.

## Features

- **Centralized Management**: Change configurations for any number of rigs from any internet-connected device.
- **Automated Monitoring**: Reduce the need for active monitoring of rigs with automated alerts.
  
## Design Goals

### Key Objectives

- **Global Configuration Management**: Change rig settings globally or selectively through a web interface.
- **Alert System**: Receive notifications via email or Telegram on rig failures.
- **Reliability**: Use a USB key as the OS storage device to ensure consistent performance.
- **Payment Simplification**: Minimize complexity related to user payments.
- **Mobile Compatibility**: Ensure functionality on smartphones and tablets.
- **User-Friendly Setup**: No need for user modification of the OS configuration file.
- **Security**: Implement robust security measures.
- **Computational Efficiency**: Balance between computational efficiency and speed as needed.

## Technical Overview

### Architecture Components

1. **NoSQL Database**: Google Datastore
2. **Back-end**: Python
3. **Front-end**: JavaScript
4. **Operating System**: modified Ubuntu 16.04 / Bash scripts

### Back-end

- Built using Python running on autoscaling containers with Google Cloud Platform (GCP) as Infrastructure as a Service (IaaS).
- The stateless back-end stores all data in the NoSQL database to ensure efficient scaling.
- A RESTful API is utilized to create, return, and modify database instances.

### Front-end

- JavaScript issues API calls to the back-end and dynamically generates DOM elements with user data based on the responses.
- User interactions trigger API calls that modify the database.
- Configuration files for rigs can be downloaded with a single button click.

### Operating System (oros)

- Based on Ubuntu 16.04 with various modifications.
- A ramdisk is generated on boot, executing a Bash script that downloads necessary files and scripts to the ramdisk.
- A Bash script controls interaction with the API, using configuration file data to access the user's account.

## Conclusion

openrig.net provides a comprehensive solution for cryptocurrency GPU mining rig management, combining ease of use with powerful features designed to enhance reliability and efficiency.
