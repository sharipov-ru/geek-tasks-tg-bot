FROM ruby:3.4.1-alpine

RUN mkdir /cmd-tasks-tg-bot

WORKDIR /cmd-tasks-tg-bot

COPY . /cmd-tasks-tg-bot

RUN gem update --system
RUN gem install bundler:2.5.11

RUN bundle config --global frozen 1
RUN bundle install

CMD ["ruby", "/cmd-tasks-tg-bot/lib/cmd_tasks_tg_bot.rb"]
