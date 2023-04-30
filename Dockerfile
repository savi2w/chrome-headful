FROM ubuntu:latest

RUN apt update
RUN apt clean

RUN useradd savi2w

WORKDIR /home/savi2w
RUN chown -R savi2w:savi2w .

RUN apt install -y xvfb fluxbox wget wmctrl gnupg2

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list

RUN apt update
RUN apt install -y google-chrome-stable

RUN apt install -y curl wget git g++ make cmake unzip libcurl4-openssl-dev autoconf libtool

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt install -y nodejs

WORKDIR /application
ADD package.json .

RUN npm install
RUN npm install aws-lambda-ric

ADD https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/latest/download/aws-lambda-rie /usr/local/bin/aws-lambda-rie
RUN chmod 755 /usr/local/bin/aws-lambda-rie

ADD bootstrap.sh /
RUN chmod 755 /bootstrap.sh

RUN rm /tmp/.X1-lock || :

ENTRYPOINT [ "/bootstrap.sh" ]

COPY . .
RUN npm run build
RUN find . -name "node_modules" -type d -prune -exec rm -r "{}" +

RUN npm install --production

WORKDIR /application/build
CMD ["chrome-headful.handler"]
