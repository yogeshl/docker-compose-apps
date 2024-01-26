**1. We will be using Docker for local development, so let’s create our necessary config files**

```bash
touch Dockerfile
touch docker-compose.yml
touch .dockerignore
```

**2. Open Dockerfile and add Node.js to our instructions. We will be installing Node.js in a container, so we do not need to have it install on our machine. On the next line, we will specify the path to our working directory.**

```docker
FROM node:19
WORKDIR /usr/src/app
```

***Docker containers run on Linux, so here we’re saying that we want our app to live in the /usr/src directory of the Linux filesystem in a project folder we want to be named app.***


**3. Open docker-compose.yml file, add config for our first service called web, which will run on port 3000.**

```yml
version: "3.8"

services:
  web:
    build: .
    ports:
      - "3000:3000"
    volumes:
      - .:/usr/src/app
```


***And with that, we can head into our terminal and spin things up with following command. At this point, it will only install Node.js in our Docker container.***

```docker
docker compose up
```

**4. Once the container is created and Node.js is installed, successfully, we can access the shell inside our Docker container by running the following command**

```docker
docker compose run --service-ports web bash
```

***Just as a sanity check, let’s see if the correct version of Node.js has been installed in our container***

```
node -v
```

**5. While still in the container, let’s initialise this project to use npm to handle our dependencies. We use the --yes flag to skip the setup wizard and give us a basic package.json file**

```
npm init --yes
```

***We will be using Express.js to give us web server functionality. So we can install that as a dependency***

```
npm install express --save
```

***Then we can create an index.js file to act as an entry point to our application***

```
touch index.js
```

***We can head over to the Express.js documentation and copy over their hello world example into our index.js file. Then we will make some minor changes to it***

```javascript
const express = require("express");
const app = express();
const port = process.env.PORT || 3000;
const host = "0.0.0.0";

app.get("/", (req, res) => {
  res.send("Hello World!");
});

app.listen(port, host, () => {
  console.log(`Example app listening on http://${host}:${port}`);
});
```

***And if we visit http://localhost:3000/, we will see the Hello World! message appear in our browser***

***Restarting the server, manually, every time we make a change is not ideal. We can work around this by installing a package called nodemon as a dev dependency. The nodemon package will help us rebuild our app whenever a change is detected.Because we installed nodemon, locally, in our application, it will not be available in our system path, so we will need to prefix the command with npx***

***While our app is running, we can open up a new terminal tab and execute the following command***

```
docker compose exec web npm install nodemon --save-dev
```

```
npx nodemon index.js
```


**6. Now what if someone clones our repository without the node_modules folder. Will our app still work as expected? No.
It would make more sense if it was installed whenever our Docker image was built. We can make changes to our Docker config to introduce this behaviour.**

***In our Dockerfile, we can add a line that will copy the package.json and package-lock.json files from our host machine into the container. Then we can also add instructions to run the npm install command***

```docker
COPY package*.json /usr/src/app/
RUN npm install
```

***Then in our docker-compose.yml file, we can add a volume to persist our node_modules data and also map a start-up command to docker compose up***

```yml
version: "3.8"

services:
  web:
    build: .
    ports:
      - "3000:3000"
    volumes:
      - .:/usr/src/app
      - node_modules:/usr/src/app/node_modules
    command: npx nodemon index.js
volumes:
  node_modules:
```

**7. Now we can exit our container to rebuild our image and fire up our app by running**

```
docker compose build
docker compose up
```

**8. Now let’s add the final touches to finalise the Dockerfile. We want to add instructions that will:**

***copy all the contents into out working directory,
expose port 3000, and
add a CMD to run our app***

```docker
FROM node:19
WORKDIR /usr/src/app


EXPOSE 3000

CMD [ "npx", "nodemon", "index.js" ]

COPY package*.json /usr/src/app/
RUN npm install

COPY . /usr/src/app/
```

***These changes will not change anything visually in the browser, but it will make it easier for our teammates to spin up the app in one command.***