# Scripts to control interaction with the overlord API, used as part of a centralized configuration and management system

## Overview

- scripts to control interaction with the overlord API, using a single configuration file to access the user's account.

- A ramdisk is generated on boot, executing the 2unix.sh script which downloads necessary files and programs from the overlord API to the ramdisk.

**openrig.net** was previously a service designed for easily managing large numbers of cryptocurrency GPU mining rigs with the overlord API. It allows for centralized configuration and management, eliminating the need to manually adjust settings on each individual rig.

## Features
- **Centralized Management**: Change configurations for any number of rigs from any internet-connected device.
- **Alert System**: Receive notifications via email or Telegram on rig failures.
- **Reliability**:  Be reliable despite using a USB key as the OS storage device
- **Payment Simplification**: Minimize complexity related to user payments.
- **Mobile Compatibility**: Ensure functionality on smartphones and tablets.
- **User-Friendly Setup**: No need for user modification of the OS configuration file.

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
