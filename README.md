# changes
added mta build tools dependency

# gitlab images
docker login registry.gitlab.com
docker build -t registry.gitlab.com/mpn2/pipeline-templates .
docker push registry.gitlab.com/mpn2/pipeline-templates 