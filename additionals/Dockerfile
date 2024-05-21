FROM mcr.microsoft.com/playwright:v1.39.0-jammy
RUN npm install -g netlify-cli serve
# The idea is to elminate '-u root' since its too risky..
RUN apt update && apt install jq -y 
