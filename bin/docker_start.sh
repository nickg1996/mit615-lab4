#!/bin/bash

set +e

echo "Attempting to migrate"
bin/rails db:migrate 2>/dev/null
RET=$?
set -e
if [ $RET -gt 0 ]; then
  echo "Migration Failed"
  bin/rails db:create
  echo "Migrating the Database"
  bin/rails db:migrate
  bin/rails db:test:prepare
  echo "Seeding the database"
  bin/rails db:seed
fi
echo "removing the old server"
rm -f tmp/pids/server.pid
echo "starting the web server"
bin/rails server -p 3000 -b '0.0.0.0'