# RSS Reader Web Application

The RSS Reader Web Application is a web interface for managing RSS feed sources, viewing a full list of currently existing posts from these sources, and managing archived posts. It consumes data from the [RSSReaderService](https://github.com/nobilik/bgwork/RSSReaderService) API.

## Pages

### Feeds

The Feeds page allows you to manage your RSS feed sources. You can add new sources, edit existing ones, or remove sources that you no longer wish to follow.

### Archive

In the Archive section, you can manage archived posts. Be aware that if you delete a post that still exists in an RSS source, it may reappear in the RSS page. Implementing a soft delete mechanism could be a solution to prevent this from happening.

## Getting Started

1. Dockerized
   Before start make sure that this app and backend are in one folder next to each other. E.g. parent->rssrails and parent->RSSReaderService
   Start the application using Docker Compose:

```bash
docker-compose up --build
```

it will starts frontend and backend together.

2. Without Docker

   1. Before running the RSS Reader Web Application, ensure that the [RSSReaderService](https://github.com/nobilik/bgwork/RSSReaderService) API is up and running. The web application makes requests to this API every minute.

   2. rails server
   3. sidekiq -C config/sidekiq.yml

3. After this open app in your browser http://localhost:3000

### License

This package is licensed under the MIT License.

## This package is created for testing purposes and not maintained
