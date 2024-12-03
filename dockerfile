# Use the official Node.js image as a base
FROM node:18-alpine AS builder

# Set the working directory inside the container for the root
WORKDIR /usr/src/app

# Copy root package.json and lock file
COPY package.json pnpm-lock.yaml ./

# Install root dependencies
RUN npm install

# Set the working directory for the backend
WORKDIR /usr/src/app/apps/backend

# Copy backend package.json and lock file
COPY apps/backend/package.json apps/backend/tsconfig.json ./

# Install backend dependencies
RUN npm install

# Copy backend application code
COPY apps/backend/src ./src

# Build the backend application if necessary
RUN npm run build

# Set the working directory for the frontend
WORKDIR /usr/src/app/apps/frontend

# Copy frontend package.json and lock file
COPY apps/frontend/package.json apps/frontend/tsconfig.json ./

# Install frontend dependencies
RUN npm install

# Copy frontend application code
COPY apps/frontend/src ./src
COPY apps/frontend/public ./public

# Build the frontend application if necessary
RUN npm run build

# Final stage for running the application
FROM node:18-alpine AS runner

# Set the working directory
WORKDIR /usr/src/app

# Copy built backend application
COPY --from=builder /usr/src/app/apps/backend/dist ./backend

# Copy built frontend application
COPY --from=builder /usr/src/app/apps/frontend/dist ./frontend

# Set environment variables
ENV ANTHROPIC_API_KEY=your_actual_api_key_here

# Expose the port that the backend app runs on
EXPOSE 3000

# Command to run the backend application
CMD ["node", "backend/index.js"]
