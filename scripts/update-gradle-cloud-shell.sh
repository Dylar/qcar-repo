#!/usr/bin/env bash

# Replaces the current existing of Gradle with 5.2.1
# Run this script directly from the command line
#
# $ curl "https://gist.githubusercontent.com/dzuluaga/80df9a5316b56c19da982054e335468a/raw/update-gradle-cloud-shell.sh?$(date +%s)" | sudo bash

export GRADLE_VERSION=7.4.2

echo 'Downloading Gradle...'
curl https://downloads.gradle.org/distributions/gradle-"${GRADLE_VERSION}"-bin.zip -o gradle-"${GRADLE_VERSION}"-bin.zip

echo 'Removing gradle from default location /opt...'
sudo rm -rf /opt/gradle

echo 'Unzipping Gradle...'
sudo unzip gradle-"${GRADLE_VERSION}"-bin.zip -d /opt

echo 'Renaming Gradle directory...'
sudo mv /opt/gradle-"${GRADLE_VERSION}" /opt/gradle

echo 'Update PATH'
export PATH=$PATH:/opt/gradle/bin