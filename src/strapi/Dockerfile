FROM strapi/strapi

# Our working directory

WORKDIR /app

# Set node env
ENV NODE_ENV=production

# Copy the required files
COPY app/package.json .
COPY app/yarn.lock .
COPY app/favicon.ico .
COPY app/api/ api/
# COPY app/components/ components/
COPY app/config/ config/
COPY app/extensions/ extensions/
# COPY app/plugins/ plugins/
COPY app/public/robots.txt public/

# Install dependencies and run build
RUN yarn --production --frozen-lockfile
RUN yarn build
EXPOSE 1337

CMD ["yarn", "start"]