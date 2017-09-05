#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status.
set -ex

echo "Building gem"
gem build companion_cube.gemspec

# Log into Artifactory
echo "Getting repository api key"
curl -su "$ART_USERNAME:$ART_API_KEY" "$ART_URL/api/v1/api_key.yaml" | tee ~/.gem/credentials

echo "Setting credential permissions"
chmod 0600 ~/.gem/credentials

echo "Publishing gem"
gem push companion_cube*.gem --host "$ART_URL"

echo "Gem published"
