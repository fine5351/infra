# loop 找尋所有 docker-compose.yml 並且執行 docker-compose down
for file in $(find . -name "docker-compose.yml"); do
  echo "Clearing $file"
  docker-compose -f $file down
done

if [ "$(docker ps -a -q)" ]; then
  docker rm $(docker ps -a -q)
else
  echo "No containers to remove"
fi

if [ "$(docker images -a -q)" ]; then
  # Force removal of images
  docker rmi -f $(docker images -a -q)  # {{ edit_1 }}
else
  echo "No images to remove"
fi