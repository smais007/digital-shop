# Use the official Node.js image as a base
FROM node:18.20.2

# Set the working directory
WORKDIR /app

# Copy package.json and yarn.lock files
COPY package.json yarn.lock ./

# Install dependencies
RUN yarn install

# Copy the rest of the application files
COPY . .

# Generate types
RUN yarn generate:types

# Build the payload, server, and Next.js application, and copy static files
RUN yarn build:payload && yarn build:server && yarn copyfiles

# Build Next.js application
RUN yarn build:next

# Set environment variables for production
ENV NODE_ENV=production
ENV PAYLOAD_CONFIG_PATH=dist/payload.config.js

# Expose the port the app runs on
EXPOSE 3000

# Start the application
CMD ["yarn", "start"]
