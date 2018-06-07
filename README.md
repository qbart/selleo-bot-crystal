# bot

## Setup

Install shards:
```
crystal deps
```

Run the app:
```
overmind s -f Procfile.dev
# or
heroku local -f Procfile.dev
```

Expose your bot so slack can send requests:
```
ngrok http 3000 -subdomain selleobot
```

Start DM3:
```
BOT_CLIENT_ID=12345 BOT_CLIENT_SECRET=secret rails s -p 3001
```

## Contributors

- [qbart](https://github.com/qbart) bart - creator, maintainer
