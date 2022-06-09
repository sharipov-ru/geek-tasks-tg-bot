FROM ruby:3.0

RUN mkdir /geek-task-tg-bot

WORKDIR /geek-task-tg-bot

COPY Gemfile /geek-task-tg-bot
COPY Gemfile.lock /geek-task-tg-bot
COPY app.rb /geek-task-tg-bot

RUN bundle config --global frozen 1
RUN bundle install

CMD ["ruby", "/geek-task-tg-bot/app.rb"]
