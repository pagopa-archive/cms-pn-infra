FROM node:14.20.0-alpine

# Our working directory

WORKDIR /app

# Set node env
ENV NODE_ENV=production

# Copy the required files
COPY app .

# Install dependencies and run build
RUN yarn --production --frozen-lockfile
RUN yarn build
EXPOSE 1337

CMD ["yarn", "start"]