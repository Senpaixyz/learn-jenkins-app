# playwright contains node as I remember so we safely
# use to call npm here...
FROM mcr.microsoft.com/playwright:v1.39.0-jammy
RUN npm install -g netlify-cli node-jq serve