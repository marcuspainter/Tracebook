# Tracebook iOS App

![Tracebook Logo](https://c2b1d9fa5c3d26f2666647d298a3ed0a.cdn.bubble.io/f1607387294628x364723563952972000/Trace_logo_2.svg)

The Tracebook website is hosted on Bubble, a no-code website builder platform. The website can expose a database using a simple REST API. 

[https://trace-book.org/](https://trace-book.org/)

## Bubble API

More information about using the Bubble API for Tracebook can be found here:

[https://manual.bubble.io/core-resources/api/the-bubble-api/the-data-api/data-api-requests](https://manual.bubble.io/core-resources/api/the-bubble-api/the-data-api/data-api-requests)

The API is limited to returning 100 items at a time. To get the next items, the cursor parameter must be used. To start, set the cursor to 0. 
The response contains the number of items remaining. Items should be retrieved until the remains count is zero.

For endpoint for each entity is:

```
https://trace-book.org/api/1.1/obj/
```

#### List Response

```
https://trace-book.org/api/1.1/obj/<entity>
```

```json
{
    "response": {
        "cursor": 0,
        "results": [
          /* entity */
        ]
        "count": 100,
        "remaining": 314
}
```

#### Item Response

```
https://trace-book.org/api/1.1/obj/<entity>/<id>
```

```json
{
    "response": {
      /* entity */
    }
}
```


## Postman

A collection of API requests used by the app can be found here:

[https://www.postman.com/marcuspainter/workspace/tracebook/collection/31672127-cdbc88fb-2808-4dc7-b574-674c5e3b7778](https://www.postman.com/marcuspainter/workspace/tracebook/collection/31672127-cdbc88fb-2808-4dc7-b574-674c5e3b7778)



## Tracebook API

Each Bubble database entity has its own endpoint.

### Measurement

https://trace-book.org/api/1.1/obj/measurement

### Measurement Content

Use the `Additional content` property from the measurement to get the measurement content.

https://trace-book.org/api/1.1/obj/measurementcontent/1701541284662x312646422310158340

### Microphone

https://trace-book.org/api/1.1/obj/microphone

### Interface

https://trace-book.org/api/1.1/obj/interface

### Analyzer

https://trace-book.org/api/1.1/obj/analyzer

### User

https://trace-book.org/api/1.1/obj/user/1660054305439x264101487122056400
