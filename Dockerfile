FROM node:18-alpine

ARG SHOPIFY_API_KEY
ENV SHOPIFY_API_KEY=$SHOPIFY_API_KEY
EXPOSE 8081
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY web .
RUN npm install
RUN cd frontend && npm install
CMD ["npm", "run", "serve"]
