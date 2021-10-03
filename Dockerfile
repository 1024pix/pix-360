FROM ruby

WORKDIR /code

ENV PORT 3000
EXPOSE $PORT

RUN gem install rails bundler
RUN gem install rails
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y nodejs yarn

ENTRYPOINT ["/bin/bash"]
