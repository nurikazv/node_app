ARG NODE_VERSION=22
ARG ALPINE_VERSION=3.21

FROM node:${NODE_VERSION}}-alpine{ALPINE_VERSION}

# Use production node enviroment by default
ENV NODE_ENV production 

# The best place to put application 
WORKDIR /usr/src/app

# Install dependency: npm ci --omit=dev
# for that we need files: package-lock.json , package.json
# Node = /root/.npm, Python = /.cache/pip # Leverage a cache mount /root/.npm to speed up subsequent builds(installation)
RUN --mount=type=bind,source=package.json,target=package.json \  
    --mount=type=bind,source=package-lock.json,target=package-lock.json \ 
    --mount=type=cache,targer=/root/.npm \
    npm ci --omit=dev
# line 15 and line 16 files and configurations for dependencies 
# line 18 command to install dependencies

USER node 
#node js has his own user "node", so no need for us to create any users

COPY . .

EXPOSE 3000

CMD node src/index.js