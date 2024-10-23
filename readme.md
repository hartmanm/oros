# scripts to control interaction with the overlord API, used as part of a centralized configuration and management system (previously openrig.net)

## Overview

- scripts control interaction with the overlord API, using a single configuration file to access the user's account.

- A ramdisk is generated on boot, executing the 2unix.sh script which downloads necessary files and programs from the overlord API to the ramdisk.

- **openrig.net** was previously (2018-2019) a service using oros and the overlord API.

## Features
- **Centralized Management**: Change configurations for any number of machines from any internet-connected device.
- **Alert System**: notifications via email or Telegram.
- **Reliability**:  avoid wear on the storage device by using a ramdisk for user operations.
- **Mobile Compatibility**: Ensure functionality on smartphones and tablets.
- **User-Friendly Setup**: No need for user modification of the OS configuration file, simply download the configuration file from your account for each machine and put it on the configuration partition once.

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
