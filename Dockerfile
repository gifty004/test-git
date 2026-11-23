FROM node:22-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build && chown -R node:node /app
USER node
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 CMD wget -q -O - http://127.0.0.1:4173/ > /dev/null || exit 1
CMD ["npm", "run", "preview", "--", "--host", "0.0.0.0"]
