FROM ruby:3.0

RUN mkdir /cmd-tasks-tg-bot

WORKDIR /cmd-tasks-tg-bot

COPY . /cmd-tasks-tg-bot

RUN bundle config --global frozen 1
RUN bundle install

CMD ["ruby", "/cmd-tasks-tg-bot/lib/cmd_tasks_tg_bot.rb"]
