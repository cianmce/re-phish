BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"

bundle exec ruby $BASE_DIR/../server/server.rb -p 3001 "$@"
