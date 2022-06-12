# cmd-tasks-tg-bot

Command line Telegram Bot - task planner


### Commands 

Sending any message to a bot creates a new task in `/inbox`

Other available commands:

```
/inbox - Show inbox tasks
/today - Show today tasks
/week - Show week tasks
/later - Show later tasks
/rm id - Remove task by id
/mvi id - Move task to inbox
/mvt id - Move task to today
/mvw id - Move task to week
/mvl id - Move task to later
```
### Tasks

All tasks have a short `id` which can be referenced in commands:

Example:

```
nc. First task
ar. Second task
fg. Third task
```

To move Third task (with the `id = fg`) to the `/later` the following command needs to be sent to Bot: `/mvl fg`


### Installation

```bash
docker build -t cmd-tasks-tg-bot  .
docker run -d -e CMD_TASKS_TG_BOT_TOKEN=TOKEN_FROM_TELEGRAM -e CMD_TASKS_REDIS_URL=redis://:password@xxx.xxx.xxx.xxx:port/0 cmd-tasks-tg-bot
```
