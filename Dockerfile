FROM node:20.12.2-alpine AS appbuild

WORKDIR /home/app

COPY . .

RUN yarn install --production --frozen-lockfile --silent

RUN yarn build

FROM node:20.12.2-alpine as app

# RUN addgroup -S user && adduser -S user -G user
# USER user

WORKDIR /home/app

COPY --from=appbuild /home/app/package.json ./package.json
COPY --from=appbuild /home/app/yarn.lock ./yarn.lock
COPY --from=appbuild /home/app/node_modules/ ./node_modules
COPY --from=appbuild /home/app/build/ ./build

CMD yarn start

FROM app as final