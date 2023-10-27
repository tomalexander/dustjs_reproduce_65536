FROM alpine:3.18.4 AS install_npm

RUN apk --no-cache add npm

# Install LinkedIn DustJS. Installing it globally before copying in
# the repo to get this cached in the docker cache so we don't spam npm
# repos every time we change the docker container.
RUN npm install -g dustjs-linkedin dustjs-helpers

FROM install_npm AS tester

#RUN apk --no-cache add bash git npm nodejs
RUN apk --no-cache add bash npm nodejs

# Create unprivileged user
RUN addgroup -S dust && adduser -S dust -G dust

# Copy repo into dust user's directory
RUN mkdir /home/dust/workdir
WORKDIR /home/dust/workdir
RUN chown -R dust:dust /home/dust
RUN npm link dustjs-linkedin dustjs-helpers

ADD entrypoint.bash /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.bash
USER dust
ADD context.json run_dust.js main.dust ./
ENTRYPOINT ["node", "/home/dust/workdir/run_dust.js", "/home/dust/workdir/context.json", "/home/dust/workdir/main.dust"]
